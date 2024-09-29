from setuptools import find_packages, setup

setup(
    name="copilot-chat-cli",
    version="1.0.0",
    packages=find_packages(),  # permet de récupérer tout les fichiers
    description="A simple chat client for copilot, with commands actions.",
    author="Raphael CHARTIER",
    license="MIT",
    python_requires=">=3.10",
)
