# AI-opsætning til kollegerne

Denne mappe har de skills og indstillinger, som bruges i AI OS. Du kan kopiere dem ind på din egen pc.
Mappen bliver lavet automatisk. Ret ikke i filerne her – dine ændringer bliver overskrevet næste gang.

Opdateret: {{DATO}} · AI OS-skills fra commit `{{AIOS_SHA}}` · projekternes skills fra {{PROJEKT_SHA}}

## Hvad er en skill?

En skill er en mappe med en vejledning (`SKILL.md`) til Claude Code eller Codex. Den virker som en
opskrift: Når du beder om en bestemt opgave, læser AI'en opskriften og følger den.

## Det er i mappen

| Mappe | Antal skills |
|---|---|
{{SKILLS_TABEL}}

- `Skills\AI-OS` – skolens fælles arbejdsgange (fx "aflever", "udgiv", "pause").
- `Skills\Projekter\<projekt>` – skills, der kun hører til ét projekt.
- `Skills\Personlige\…` – skills, som JST bruger til sit eget arbejde.
- `Indstillinger\VSCode`, `Indstillinger\ClaudeCode`, `Indstillinger\Codex` – JSTs indstillinger. Brug dem som eksempel.

## Sådan bruger du en skill

1. Vælg den skill, du vil bruge, fx `Skills\AI-OS\pause`.
2. Kopiér hele mappen (ikke kun `SKILL.md`).
3. Til **Claude Code**: Sæt den ind i `%USERPROFILE%\.claude\skills\`.
4. Til **Codex**: Sæt den ind i `%USERPROFILE%\.agents\skills\`.
5. Genstart Claude Code eller Codex.

Advarsel: Nogle skills i `Skills\AI-OS` arbejder med JSTs egne mapper og med Y:. Læs `SKILL.md`, før
du bruger dem.

## Sådan bruger du indstillingerne

Overskriv ikke dine egne filer. Åbn begge filer, og kopiér kun de linjer, du vil have.

| Fil i mappen | Din egen fil |
|---|---|
| `Indstillinger\VSCode\settings.json` | `%APPDATA%\Code\User\settings.json` |
| `Indstillinger\VSCode\keybindings.json` | `%APPDATA%\Code\User\keybindings.json` |
| `Indstillinger\VSCode\extensions.txt` | Listen over udvidelser ({{UDVIDELSER}} stk.). Installér en udvidelse med `code --install-extension <navn>` |
| `Indstillinger\ClaudeCode\settings.json` | `%USERPROFILE%\.claude\settings.json` |
| `Indstillinger\ClaudeCode\statusline-command.ps1` | `%USERPROFILE%\.claude\statusline-command.ps1` |
| `Indstillinger\ClaudeCode\themes\*.json` | `%USERPROFILE%\.claude\themes\` ({{TEMAER}} farvetemaer). Vælg et i `settings.json` med `"theme": "custom:<filnavn uden .json>"` |
| `Indstillinger\ClaudeCode\mods\<navn>` | Tilføjelser til Claude Code ({{MODS}}). Hos JST ligger de i `%USERPROFILE%\.claude\mods\<navn>` og er installeret derfra som plugin. Kopiér mappen til samme sted, og bed Claude Code om at installere den |
| `Indstillinger\Codex\config.toml` | `%USERPROFILE%\.codex\config.toml` |

Stierne til JSTs OneDrive er skiftet ud med `Y:\AI OS` og `Y:\AI SOSU`. Stierne til JSTs profil er
skiftet ud med `%USERPROFILE%`.

## Det er bevidst ikke med

- **Login, adgangskoder og historik.** Det er personligt og må aldrig deles.
- **Codex-indstillinger med JSTs mapper og maskine:** {{CODEX_FJERNET}}.
- **ADM-BESPARELSER** og andre fortrolige projekter.
- **Skills, hvor licensen ikke tillader deling.** Hent dem selv fra Anthropic:
{{LAAST}}
- **Dubletter** (samme navn to gange i samme kilde – kun den første er med):
{{DUBLETTER}}

## Hvis noget går galt

| Det ser du | Det betyder det | Gør dette |
|---|---|---|
| Skillen dukker ikke op | Mappen ligger forkert, eller programmet er ikke genstartet | Kontrollér, at `SKILL.md` ligger direkte i skillens mappe. Genstart programmet |
| Claude Code starter ikke efter du har kopieret `settings.json` | Filen peger på noget, du ikke har (fx et plugin) | Læg din gamle fil tilbage, og kopiér kun enkelte linjer |
| En sti peger på `C:\Users\jst` | Den blev ikke skiftet ud | Sig det til JST |
