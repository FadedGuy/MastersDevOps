@echo off

echo Fetch and Pull MastersDevOps
git fetch --all --progress -v
git pull --all --progress -v

echo Fetch and Pull Vault
cd D:\Documents\Vault
git fetch --all --progress -v
git pull --all --progress -v
