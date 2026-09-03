#!/usr/bin/env bash
#
# Runs automatically as postCreateCommand when a Codespace is created.
#
# set -e matters here: without it a failed pip install still exits 0, and the
# student gets a Codespace that looks ready but has no packages in it.
set -euo pipefail

echo "==> Installing Python packages (this takes a few minutes on first launch)..."
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

# Streamlit prompts for an email address on its first run, which stalls
# 'streamlit run' at a prompt students don't expect. Pre-empt it.
mkdir -p "$HOME/.streamlit"
if [ ! -f "$HOME/.streamlit/credentials.toml" ]; then
	printf '[general]\nemail = ""\n' > "$HOME/.streamlit/credentials.toml"
fi

echo
echo "==> Setup complete."
if [ -z "${OPENAI_API_KEY:-}" ]; then
	echo "    NOTE: OPENAI_API_KEY is not set. Add it as a Codespaces secret"
	echo "          and rebuild — see the README for step-by-step instructions."
else
	echo "    OPENAI_API_KEY is set."
fi
