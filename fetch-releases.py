#! /usr/bin/env nix-shell
#! nix-shell -i python3.11 -p python311 python311Packages.requests nix

import json
import requests
import subprocess
import re


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


def save_to_json(sources: dict, filename: str):
    """
    Save json to a file

    Parameters
    ----------
    json : list
        JSON data which will be saved to a file
    filename : str
        File name to save the JSON data
    """
    with open(filename, "w") as file:
        json.dump(sources, file, indent=2)


def gen_nix_hash(url: str) -> str:
    """
    Generate nix-hash from url by using nix-prefetch-url

    Parameters
    ----------
    url : str
        URL of the file to fetch

    Returns
    -------
    hash : str
        Nix hash of the file

    >>> gen_nix_hash("https://github.com/denoland/deno/releases/download/v1.42.0/deno-x86_64-unknown-linux-gnu.zip")
    0brv6v98jx2b2mwhx8wpv2sqr0zp2bfpiyv4ayziay0029rxldny
    """
    result = subprocess.run(["nix-prefetch-url", "--unpack", url], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    return result.stdout.replace("\n", "")


def gen_list_of_download_link(sources: dict) -> list:
    result: list = []

    for version in sources:
        for assets in version["assets"]:
            result.append(assets["browser_download_url"])

    return result


def filter_godot_v4_link(urls: list) -> list:
    result: list = []

    for url in urls:
        if "Godot_v4" in url:
            result.append(url)

    return result


def filter_godot_v3_link(urls: list) -> list:
    result: list = []

    for url in urls:
        if "Godot_v3" in url:
            result.append(url)

    return result


def gen_list_of_versions(sources: list) -> list:
    result: list = []

    for version in sources:
        result.append(version["tag_name"])

    return result


def gen_v4_x64_releases(versions: list, v4_x64_urls: list) -> list:
    result: list = []

    for version in versions:
        for url in v4_x64_urls:
            if version in url and "mono_linux_x86_64" in url:
                result.append(url)

    return result


def gen_v3_x64_releases(versions: list, v3_x64_urls: list) -> list:
    result: list = []

    for version in versions:
        for url in v3_x64_urls:
            if version in url and "mono_x11_64" in url:
                result.append(url)

    return result


def gen_releases(versions: list, v3_x64_urls: list, v4_x64_urls: list) -> list:
    result: list = []

    print("Number of versions: ", len(versions))

    for url in v4_x64_urls:
        for version in versions:
            if is_correct_version_url(version, url):
                print("Generating nix hash for: ", url)
                sha256 = gen_nix_hash(url)

                result.append({ "version": version, "url": url, "sha256": sha256, "arch": "x86_64-linux" })

    for url in v3_x64_urls:
        for version in versions:
            if is_correct_version_url(version, url):
                print("Generating nix hash for: ", url)
                sha256 = gen_nix_hash(url)

                result.append({ "version": version, "url": url, "sha256": sha256, "arch": "x86_64-linux" })

    return result


def is_correct_version_url(version: str, url: str) -> bool:
    pattern = r"releases/download/(\d+\.\d+\.\d+\-stable)/Godot_"
    match = re.search(pattern, url)

    if match:
        return match.group(1) == version


if __name__ == "__main__":
    owner: str = "godotengine"
    repo: str = "godot"
    destination: str = "sources.json"

    godot_info: list = get_all_releases(owner, repo)
    versions: list = gen_list_of_versions(godot_info)
    urls: list = gen_list_of_download_link(godot_info)
    godot_v4_urls: list = filter_godot_v4_link(urls)
    godot_v3_urls: list = filter_godot_v3_link(urls)
    godot_v4_x64_urls: list = gen_v4_x64_releases(versions, godot_v4_urls)
    godot_v3_x64_urls: list = gen_v3_x64_releases(versions, godot_v3_urls)
    releases: list = gen_releases(versions, godot_v3_x64_urls, godot_v4_x64_urls)

    save_to_json({ "godot-bin": { "mono": releases } }, destination)
    print("Done!!")
