#! /usr/bin/env nix-shell
#! nix-shell -i python3.11 -p python311 python311Packages.requests nix

import json
import requests


def get_all_releases(owner: str, repo: str) -> list:
    """
    Get all releases of a repository

    Parameters
    ----------
    owner : str
        Owner of the repository
    repo : str
        Name of the repository

    Returns
    -------
    releases : list
        List of releases of the repository
    """
    url = f"https://api.github.com/repos/{owner}/{repo}/releases"
    releases = []
    page = 1

    while True:
        response = requests.get(url, params={"page": page})
        if response.status_code == 200:
            releases_page = json.loads(response.text)
            if not releases_page:
                break  # ページが空の場合、ループを終了します。
            releases.extend(releases_page)
            page += 1
        else:
            print(f"Failed to fetch releases: {response.status_code} - {response.text}")
            break

    return releases
