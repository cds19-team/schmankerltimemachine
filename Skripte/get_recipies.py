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

#

threshold = 0.6

def process(items: DataFrame, threshold: float):
    api = ChefkochApi()
    df = pd.DataFrame(columns=['item_id', 'recipy_id'])
    for idx, item in items.iterrows():
        recipes = api.search_recipe(query=item, limit=1)
        results = recipes['results']
        if len(results) > 0:
            if results[0]['score'] > threshold:
                df = df.append({'item_id': idx, 'recipy_id': results[0]['recipe']['id']}, ignore_index=True)

    df.to_csv(r'recipies.csv', header=True, index_label="idx")


if __name__ == "__main__":

    nr_args = len(sys.argv) - 1
    if nr_args < 1:
        print("Specify the items.csv path as parameter")
    else:
        if nr_args > 1:
            threshold = sys.argv[2]
        file = sys.argv[1]
        content = pd.read_csv(file)
        process(content, threshold)
