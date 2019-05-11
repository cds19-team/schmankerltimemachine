#!/usr/local/bin/python
# coding: utf-8
import sys
import re
import csv
import pandas as pd
import bs4 as bs
import numpy as np
from bs4 import BeautifulSoup
from bs4.element import Tag
from pandas import DataFrame

__author__ = "Linus Kohl"
__version__ = "0.1-dev"
__email__ = "linus@riskl.io"
__license__ = "GPLv3"

# regular expression to get the id of the corresponding page
page_id_regex = r"facs_([\d]*)_|$"
# Chars that will be removed from entities
bad_chars = '[]'
bad_chars_trans = str.maketrans("", "", bad_chars)


def load_tei_file(filename: str) -> BeautifulSoup:
    """Loads TEI File and returns BeatufiulSoup
    Args:
        filename (str): Name of the file to load
    Returns:
        BeautifulSoup Object
    Raises:
        Exception
    """
    with open(filename, "r") as f:
        content = f.read()
        return bs.BeautifulSoup(content, 'lxml')


def clean_string(text: str) -> str:
    """Removes bad characters from given string
    Args:
        text (str): String to remove bad characters from
    Returns:
        str
    """
    return text.translate(bad_chars_trans)


def clean_price(price_string: str) -> float:
    """Cleans prices and converts them to floats or NaN if it fails
    Args:
        price_string (str): String containing price that will be converted to float
    Returns:
        float
    """
    price = np.nan
    try:
        price_string = price_string.replace(",", ".")
        price = float(price_string)
    except Exception:
        pass
    return price


def get_entry_id(entry: Tag) -> str:
    """Extracts the ID of a TEI elemnt
    Args:
        entry (Tag): Element
    Returns:
        str: ID
    """
    try:
        if entry.parent.name != 'l':
            return None
        return entry.parent['facs'].replace("#", "")
    except:
        return None


def get_page_id(entry_id: str) -> str:
    """Get the number of the page of the element
    Args:
        entry_id (str): ID of the element
    Returns:
        str: Number of the page
    """
    if isinstance(entry_id, str):
        page_id_matches = re.findall(page_id_regex, entry_id)
        page_id = page_id_matches[0] if len(page_id_matches) > 0 else None
        return page_id
    return None


def get_tags(soup: BeautifulSoup, tag_name: str) -> DataFrame:
    """Process soup and extract all elements of type tag_name
    Args:
        soup (BeautifulSoup): content of the TEI file
        tag_name (str): Name of the element
    Returns:
        DataFrame: Frame containing a row per element
    """
    df = pd.DataFrame(columns=['page_id', 'value'])
    query = soup.find_all(tag_name)
    for tag in query:
        entry_id = get_entry_id(tag)
        page_id = get_page_id(entry_id)
        value = tag.text
        df = df.append({'page_id': page_id, 'value': value}, ignore_index=True)
    return df


def process(soup: BeautifulSoup) -> None:
    """Process content of TEI file and extract data
    Args:
        soup (BeautifulSoup): Soup of the TEI file
    Returns:
        None
    Raises:
        Exception
    """
    # init dataframes
    items = pd.DataFrame(columns=['description'])
    entries = pd.DataFrame(columns=['page_id', 'item_id', 'price', 'quantity'])
    zones = pd.DataFrame(columns=['entry_id', 'x1', 'y1', 'x2', 'y2'])

    # loop over all entries
    for entry in soup.find_all("eintrag"):
        # init attributes
        name = None
        item_id = None
        price = np.nan
        quantity = None

        entry_id = get_entry_id(entry)
        page_id = get_page_id(entry_id)
        if page_id is None:
            continue  # could not assign entry to page
        # process the name
        name_entry = entry.find('name')
        if name_entry is not None:
            name = clean_string(name_entry.text)
            # find existing item
            item_ids = items.index[items['description'] == name]
            if len(item_ids) == 0:
                # add new item to dataframe
                items = items.append({'description': name}, ignore_index=True)
                item_id = items.index.max()
            else:
                item_id = item_ids[0]
        # process price
        price_entry = entry.find('preis')
        if price_entry is not None:
            price = clean_price(price_entry.text)
        # process quantities
        quantity_entry = entry.find('Mengenangabe')
        if quantity_entry is not None:
            quantity = quantity_entry.text
        # add entries to dataframes
        entries = entries.append(
            {'page_id': page_id, 'item_id': item_id, 'price': price,
             'quantity': quantity}, ignore_index=True)
        e_id = entries.index.max()

        # get coordinates of the line
        zone = content.find("zone", {"xml:id": entry_id})
        if zone is not None:
            lrx = zone.get('lrx')
            lry = zone.get('lry')
            ulx = zone.get('ulx')
            uly = zone.get('uly')
            zone_obj = {'entry_id': e_id,
                        'x1': int(lrx) if lrx else np.nan,
                        'y1': int(lry) if lry else np.nan,
                        'x2': int(ulx) if ulx else np.nan,
                        'y2': int(uly) if uly else np.nan}
            zones = zones.append(zone_obj, ignore_index=True)

    owners = get_tags(content, 'inhaber')
    addresses = get_tags(content, 'address')
    categories = get_tags(content, 'kategorie')

    items.to_csv(r'items.csv', header=True, index_label="idx", quoting=csv.QUOTE_NONNUMERIC)
    entries.to_csv(r'entries.csv', header=True, index_label="idx", quoting=csv.QUOTE_NONNUMERIC)
    zones.to_csv(r'zones.csv', header=True, index_label="idx", quoting=csv.QUOTE_NONNUMERIC)
    owners.to_csv(r'owners.csv', header=True, index_label="idx", quoting=csv.QUOTE_NONNUMERIC)
    addresses.to_csv(r'addresses.csv', header=True, index_label="idx", quoting=csv.QUOTE_NONNUMERIC)
    categories.to_csv(r'categories.csv', header=True, index_label="idx", quoting=csv.QUOTE_NONNUMERIC)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Specify TEI path as parameter")
    else:
        file = sys.argv[1]
        content = load_tei_file(file)
        process(content)

