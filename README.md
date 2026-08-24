# Anya-Codex-Pet-Share

Anya - Codex V2 Animated Pet
================================

Windows one-click installation
------------------------------
1. Extract the ZIP completely. Do not run the installer from inside the ZIP preview.
2. Double-click Install-Anya.cmd.
3. Restart Codex.
4. Open Settings > Pets, select Refresh, and choose Anya.
5. Enter /pet to wake the pet.

The installer:
- verifies pet.json and spritesheet.webp with SHA-256;
- installs to %USERPROFILE%\.codex\pets\anya-forger;
- backs up different existing Anya files before replacement;
- does not require administrator privileges;
- does not delete existing files.

Manual installation
-------------------
Copy pet.json and spritesheet.webp to:

  Windows: %USERPROFILE%\.codex\pets\anya-forger\
  macOS/Linux: ~/.codex/pets/anya-forger/

Required final structure:

  .codex/
  `-- pets/
      `-- anya-forger/
          |-- pet.json
          `-- spritesheet.webp

Notes
-----
- This is a local Codex V2 pet package: 1536 x 2288, spriteVersionNumber 2.
- Local custom pets do not automatically sync to ChatGPT web.
- The current documented web uploader expects a different 1536 x 1872 sheet.
- Share only where you have the necessary rights to use and distribute the character artwork.

