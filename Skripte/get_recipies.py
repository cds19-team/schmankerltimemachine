#!/usr/local/bin/python
# coding: utf-8
import sys
import os
import csv
import pandas as pd
import bs4 as bs
import numpy as np
from pandas import DataFrame
sys.path.append(os.path.abspath(os.path.join('.', 'Chefkoch','chefkoch-api')))
from chefkoch import ChefkochApi

__author__ = "Linus Kohl"
__version__ = "0.1-dev"
__email__ = "linus@riskl.io"
__license__ = "GPLv3"

def process(items: DataFrame):
    api = ChefkochApi()
    for item in items.iterrows():
        recipes = api.search_recipe(query=item, limit=1)
        results = recipes['results']
        if len(results) > 0:
            print(results[0]['recipe']['id'])

    #categories.to_csv(r'categories.csv', header=True, index_label="idx", quoting=csv.QUOTE_NONNUMERIC)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Specify the items.csv path as parameter")
    else:
        file = sys.argv[1]
        content = pd.read_csv(file)
        process(content)

