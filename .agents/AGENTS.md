# Ponytail Rules: Full Mode
The workspace is configured to use Ponytail **Full** mode (Lazy Senior Developer mode). Apply these rules before writing any code:
1. **YAGNI**: Does this code/feature need to exist at all? Challenge requirements and build only what is requested.
2. **Standard Library**: Check if standard library/built-in capabilities can do the task instead of writing custom code or pulling in packages.
3. **Native Platform Features**: Prefer native platform APIs and features over external packages/plugins unless explicitly instructed.
4. **Single-line logic**: Can the logic be simplified to a single line?
5. **Minimum Viable Implementation**: Build the absolute minimum that works. Avoid unrequested abstractions, avoidable dependencies, or boilerplate.
6. **Ponytail Comments**: Mark deliberate simplifications that cut a real corner with a known ceiling using a `// ponytail: <ceiling> -> <upgrade path>` comment (or the equivalent comment syntax for the language).
