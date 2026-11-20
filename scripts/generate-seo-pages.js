
const fs = require("fs");
const path = require("path");

// --------------------------------------------------
// WHOSWHO SEO PAGE GENERATOR
// --------------------------------------------------

const PROJECT_ID = "whoswho-57e96";

const BASE_URL = (
  process.env.WHOSWHO_BASE_URL ||
  "https://whoswho-57e96.web.app"
).replace(/\/+$/, "");

const FIRESTORE_URL =
  `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/publicProfiles`;

const WEB_ROOT = path.join(__dirname, "..", "build", "web");

// --------------------------------------------------
// FIRESTORE VALUE DECODER
// --------------------------------------------------

function decodeValue(value) {
  if (!value || typeof value !== "object") return null;

  if ("stringValue" in value) return value.stringValue;
  if ("integerValue" in value) return Number(value.integerValue);
  if ("doubleValue" in value) return value.doubleValue;
  if ("booleanValue" in value) return value.booleanValue;
  if ("timestampValue" in value) return value.timestampValue;
  if ("nullValue" in value) return null;

  if ("arrayValue" in value) {
    return (value.arrayValue.values || []).map(decodeValue);
  }

  if ("mapValue" in value) {
    return decodeFields(value.mapValue.fields || {});
  }

  return null;
}

function decodeFields(fields) {
  const result = {};

  for (const [key, value] of Object.entries(fields || {})) {
    result[key] = decodeValue(value);
  }

  return result;
}

// --------------------------------------------------
// HTML AND URL HELPERS
// --------------------------------------------------

function escapeHtml(value) {
  return String(value ?? "").replace(/[&<>"']/g, character => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#39;"
  })[character]);
}

function slugify(value) {
  return String(value || "profile")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "") || "profile";
}

function textValue(value) {
  if (Array.isArray(value)) {
    return value.filter(Boolean).join(", ");
  }

  return String(value || "").trim();
}

function makeUrl(value) {
  const url = String(value || "").trim();

  if (!url) return "";

  if (/^https?:\/\//i.test(url)) return url;

  return "https://" + url;
}

function shorten(value, limit = 160) {
  const text = textValue(value).replace(/\s+/g, " ").trim();

  if (text.length <= limit) return text;

  return text.substring(0, limit - 3).trim() + "...";
}

function xmlEscape(value) {
  return String(value).replace(/[<>&'"]/g, character => ({
    "<": "&lt;",
    ">": "&gt;",
    "&": "&amp;",
    "'": "&apos;",
    '"': "&quot;"
  })[character]);
}

// --------------------------------------------------
// PROFILE INFORMATION
// --------------------------------------------------

function buildProfile(document) {
  const id = document.name.split("/").pop();
  const fields = decodeFields(document.fields || {});

  const accountType = fields.accountType;

  if (accountType === "Professional") {
    const profile = fields.professionalProfile || {};

    const name = textValue(profile.fullName || fields.fullName);

    if (!name) return null;

    const profession = textValue(profile.professions);
    const location = [
      profile.city,
      profile.country
    ].filter(Boolean).join(", ");

    const description = shorten(
      profile.aboutMe ||
      `${name} is a ${profession} on WhosWho. Discover their professional profile and services.`
    );

    return {
      id,
      type: "professional",
      name,
      heading: profession || "Professional",
      salutation: textValue(profile.salutation),
      streetName: textValue(profile.streetName),
      location,
      addressLocality: textValue(profile.city),
      addressCountry: textValue(profile.country),
      description,
      services: textValue(profile.services),
      skills: textValue(profile.skills),
      languages: textValue(profile.languages),
      availability: textValue(profile.availability),
      experience: textValue(profile.yearsOfExperience),
      education: textValue(profile.education),
      certifications: textValue(profile.certifications),
      website: makeUrl(profile.website),
      email: textValue(profile.email),
      telephone: textValue(profile.telephone),
      whatsapp: textValue(profile.whatsApp),
      socialMedia: profile.socialMedia || {},
      additionalSocialMedia: profile.additionalSocialMedia || [],
      updatedAt: profile.updatedAt || fields.updatedAt
    };
  }

  if (accountType === "Business") {
    const profile = fields.businessProfile || {};

    const name = textValue(profile.businessName || fields.fullName);

    if (!name) return null;

    const category = textValue(
      profile.customBusinessType ||
      profile.businessCategory ||
      profile.industry ||
      "Business"
    );

    const location = [
      profile.physicalAddress,
      profile.country
    ].filter(Boolean).join(", ");

    const description = shorten(
      profile.aboutUs ||
      `${name} is a business listed on WhosWho. Discover its services and contact information.`
    );

    return {
      id,
      type: "business",
      name,
      heading: category,
      industry: textValue(profile.industry),
      location,
      addressLocality: textValue(profile.physicalAddress),
      addressCountry: textValue(profile.country),
      description,
      services: textValue(profile.services),
      skills: "",
      languages: textValue(profile.languages),
      availability: textValue(profile.availability),
      experience: "",
      education: "",
      certifications: "",
      website: makeUrl(profile.website),
      email: textValue(profile.email),
      telephone: textValue(profile.telephone),
      whatsapp: textValue(profile.whatsApp),
      socialMedia: profile.socialMedia || {},
      additionalSocialMedia: profile.additionalSocialMedia || [],
      updatedAt: profile.updatedAt || fields.updatedAt
    };
  }

  return null;
}

// --------------------------------------------------
// SOCIAL MEDIA LINKS
// --------------------------------------------------

function buildSocialLinks(profile) {
  const links = [];

  for (const [platform, value] of Object.entries(profile.socialMedia || {})) {
    const url = makeUrl(value);

    if (url) {
      links.push(
        `<li><a href="${escapeHtml(url)}" rel="noopener noreferrer">${escapeHtml(platform)}</a></li>`
      );
    }
  }

  for (const item of profile.additionalSocialMedia || []) {
    if (item && item.link) {
      const url = makeUrl(item.link);

      links.push(
        `<li><a href="${escapeHtml(url)}" rel="noopener noreferrer">${escapeHtml(item.platform || "Social media")}</a></li>`
      );
    }
  }

  return links.join("\n");
}

// --------------------------------------------------
// GENERATE INDIVIDUAL HTML PAGE
// --------------------------------------------------

function generateHtml(profile, profileUrl) {
  const title = `${profile.name} - ${profile.heading} | WhosWho`;

  const description = profile.description;

  const isProfessional = profile.type === "professional";

  const schema = {
    "@context": "https://schema.org",
    "@type": isProfessional ? "Person" : "Organization",
    "name": profile.name,
    "description": description,
    "url": profileUrl
  };

  if (isProfessional) {
    schema.jobTitle = profile.heading;
  }

  if (profile.telephone) schema.telephone = profile.telephone;
  if (profile.email) schema.email = profile.email;
   const sameAsLinks = [];

  if (profile.website) {
    sameAsLinks.push(profile.website);
  }

  for (const value of Object.values(profile.socialMedia || {})) {
    const url = makeUrl(value);
    if (url) sameAsLinks.push(url);
  }

  for (const item of profile.additionalSocialMedia || []) {
    if (item && item.link) {
      const url = makeUrl(item.link);
      if (url) sameAsLinks.push(url);
    }
  }

  schema.sameAs = [...new Set(sameAsLinks)];

   if (profile.addressLocality || profile.addressCountry) {
    schema.address = {
      "@type": "PostalAddress",
      ...(profile.addressLocality ? {
        "addressLocality": profile.addressLocality
      } : {}),
      ...(profile.addressCountry ? {
        "addressCountry": profile.addressCountry
      } : {})
    };
  }

  const jsonLd = JSON.stringify(schema)
    .replace(/</g, "\\u003c");

  const contact = [];

  if (profile.telephone) {
    contact.push(
      `<p><strong>Telephone:</strong> <a href="tel:${escapeHtml(profile.telephone)}">${escapeHtml(profile.telephone)}</a></p>`
    );
  }

   if (profile.whatsapp) {
   let whatsappNumber = profile.whatsapp.replace(/\D/g, "");

if (String(profile.addressCountry || "").toLowerCase() === "kenya") {
  if (whatsappNumber.startsWith("0")) {
    whatsappNumber = "254" + whatsappNumber.substring(1);
  } else if (whatsappNumber.length === 9) {
    whatsappNumber = "254" + whatsappNumber;
  }
}

    contact.push(
      `<p><strong>WhatsApp:</strong> <a href="https://wa.me/${escapeHtml(whatsappNumber)}" target="_blank" rel="noopener noreferrer">${escapeHtml(profile.whatsapp)}</a></p>`
    );
  }

  if (profile.email) {
    contact.push(
      `<p><strong>Email:</strong> <a href="mailto:${escapeHtml(profile.email)}">${escapeHtml(profile.email)}</a></p>`
    );
  }

  if (profile.website) {
    contact.push(
      `<p><strong>Website:</strong> <a href="${escapeHtml(profile.website)}" rel="noopener noreferrer">${escapeHtml(profile.website)}</a></p>`
    );
  }

  const sections = [];

  if (profile.location) {
    sections.push(`<p><strong>Location:</strong> ${escapeHtml(profile.location)}</p>`);
  }
  if (profile.salutation) {
    sections.push(`<p><strong>Salutation:</strong> ${escapeHtml(profile.salutation)}</p>`);
  }

  if (profile.streetName) {
    sections.push(`<p><strong>Street:</strong> ${escapeHtml(profile.streetName)}</p>`);
  }

  if (profile.industry) {
    sections.push(`<p><strong>Industry:</strong> ${escapeHtml(profile.industry)}</p>`);
  }

  if (profile.languages) {
    sections.push(`<p><strong>Languages:</strong> ${escapeHtml(profile.languages)}</p>`);
  }

  if (profile.availability) {
    sections.push(`<p><strong>Availability:</strong> ${escapeHtml(profile.availability)}</p>`);
  }

  if (profile.services) {
    sections.push(`<h2>Services</h2><p>${escapeHtml(profile.services)}</p>`);
  }

  if (profile.skills) {
    sections.push(`<h2>Skills</h2><p>${escapeHtml(profile.skills)}</p>`);
  }

  if (profile.experience) {
    sections.push(`<p><strong>Experience:</strong> ${escapeHtml(profile.experience)}</p>`);
  }

  if (profile.education) {
    sections.push(`<p><strong>Education:</strong> ${escapeHtml(profile.education)}</p>`);
  }

  if (profile.certifications) {
    sections.push(`<p><strong>Certifications:</strong> ${escapeHtml(profile.certifications)}</p>`);
  }

  const socialLinks = buildSocialLinks(profile);

  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>${escapeHtml(title)}</title>

<meta name="description" content="${escapeHtml(description)}">
<meta name="robots" content="index, follow">

<link rel="canonical" href="${escapeHtml(profileUrl)}">

<meta property="og:type" content="profile">
<meta property="og:title" content="${escapeHtml(title)}">
<meta property="og:description" content="${escapeHtml(description)}">
<meta property="og:url" content="${escapeHtml(profileUrl)}">
<meta property="og:site_name" content="WhosWho">

<meta name="twitter:card" content="summary">
<meta name="twitter:title" content="${escapeHtml(title)}">
<meta name="twitter:description" content="${escapeHtml(description)}">

<script type="application/ld+json">${jsonLd}</script>

<style>
body {
  font-family: Arial, sans-serif;
  max-width: 850px;
  margin: 35px auto;
  padding: 0 20px;
  line-height: 1.7;
  color: #333;
}
header {
  background: #493022;
  color: white;
  padding: 22px;
  border-radius: 8px;
}
header a {
  color: white;
}
h1 { margin-bottom: 5px; }
h2 { color: #493022; margin-top: 28px; }
a { color: #1769aa; }
footer {
  margin-top: 40px;
  border-top: 1px solid #ddd;
  padding-top: 20px;
}
</style>
</head>

<body>

<header>
  <strong>WhosWho</strong>
  <p>Find Professionals, Find Services</p>
  <a href="${BASE_URL}/">Visit WhosWho</a>
</header>

<main>

<h1>${escapeHtml(profile.name)}</h1>

<h2>${escapeHtml(profile.heading)}</h2>

<p>${escapeHtml(description)}</p>

${sections.join("\n")}

${contact.length ? `<h2>Contact Information</h2>${contact.join("\n")}` : ""}

${socialLinks ? `<h2>Social Media</h2><ul>${socialLinks}</ul>` : ""}

</main>

<footer>
  <p>Discover professionals, businesses and services on
  <a href="${BASE_URL}/">WhosWho</a>.</p>
</footer>

</body>
</html>`;
}

// --------------------------------------------------
// RETRIEVE ALL PUBLIC PROFILES
// --------------------------------------------------

async function getAllProfiles() {
  const documents = [];
  let pageToken = "";

  do {
    const url = new URL(FIRESTORE_URL);

    url.searchParams.set("pageSize", "1000");

    if (pageToken) {
      url.searchParams.set("pageToken", pageToken);
    }

    const response = await fetch(url);

    if (!response.ok) {
      const errorText = await response.text();

      throw new Error(
        `Firestore request failed (${response.status}): ${errorText}`
      );
    }

    const result = await response.json();

    documents.push(...(result.documents || []));

    pageToken = result.nextPageToken || "";

  } while (pageToken);

  return documents;
}

// --------------------------------------------------
// MAIN GENERATOR
// --------------------------------------------------

async function main() {
  console.log("Starting WhosWho SEO page generation...");
  console.log("Firebase project:", PROJECT_ID);
  console.log("Website:", BASE_URL);

  if (!fs.existsSync(WEB_ROOT)) {
    throw new Error(
      "Flutter Web build not found. Build Flutter Web first."
    );
  }

  const documents = await getAllProfiles();

  let professionalCount = 0;
  let businessCount = 0;

  const sitemapEntries = [];

  for (const document of documents) {
    const profile = buildProfile(document);

    if (!profile) continue;

    const folder = profile.type === "professional"
      ? "professionals"
      : "businesses";

    const safeId = slugify(profile.id);
    const folderName = `${slugify(profile.name)}-${safeId}`;

    const outputFolder = path.join(
      WEB_ROOT,
      folder,
      folderName
    );

    fs.mkdirSync(outputFolder, { recursive: true });

    const profileUrl =
      `${BASE_URL}/${folder}/${folderName}/`;

    const html = generateHtml(profile, profileUrl);

    fs.writeFileSync(
      path.join(outputFolder, "index.html"),
      html,
      "utf8"
    );

    sitemapEntries.push(
      `<url><loc>${xmlEscape(profileUrl)}</loc></url>`
    );

    if (profile.type === "professional") {
      professionalCount++;
    } else {
      businessCount++;
    }
  }

  const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${sitemapEntries.join("\n")}
</urlset>`;

  fs.writeFileSync(
    path.join(WEB_ROOT, "sitemap.xml"),
    sitemap,
    "utf8"
  );

  fs.writeFileSync(
    path.join(WEB_ROOT, "robots.txt"),
    `User-agent: *\nAllow: /\n\nSitemap: ${BASE_URL}/sitemap.xml\n`,
    "utf8"
  );

  console.log("----------------------------------");
  console.log("SEO GENERATION COMPLETED");
  console.log("Professionals:", professionalCount);
  console.log("Businesses:", businessCount);
  console.log("Total pages:", sitemapEntries.length);
  console.log("Sitemap: build/web/sitemap.xml");
  console.log("----------------------------------");
}

main().catch(error => {
  console.error("SEO generation failed:");
  console.error(error.message);
  process.exitCode = 1;
});
