#!/usr/bin/env bash
set -euo pipefail

ENV_NAME="lerobot"
ROOT_PREFIX="${MAMBA_ROOT_PREFIX:-$PWD/.mamba}"

mkdir -p "$ROOT_PREFIX"

# Create env (Python 3.10 per LeRobot docs)
if ! micromamba env list -r "$ROOT_PREFIX" | awk '{print $1}' | grep -qx "$ENV_NAME"; then
  micromamba create -y -r "$ROOT_PREFIX" -n "$ENV_NAME" -c conda-forge python=3.10
fi

# ffmpeg per LeRobot docs
micromamba install -y -r "$ROOT_PREFIX" -n "$ENV_NAME" -c conda-forge ffmpeg

# pip tooling
micromamba run -r "$ROOT_PREFIX" -n "$ENV_NAME" python -m pip install -U pip setuptools wheel

# LeRobot for SO-ARM101/SO-101 (Feetech extra)
micromamba run -r "$ROOT_PREFIX" -n "$ENV_NAME" python -m pip install "lerobot[feetech]"

echo "OK. Test:"
echo "  micromamba run -r \"$ROOT_PREFIX\" -n \"$ENV_NAME\" python -c \"import lerobot; print('lerobot ok')\""
