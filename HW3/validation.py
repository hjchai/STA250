# -*- coding: utf-8 -*-
"""
Created on Sat Mar 22 11:42:30 2014

@author: huajun
        @fastml
"""

import sys, csv, re

with open("data/train.csv") as myfile:
    head=myfile.readlines(10)
with open("valid.csv",'w') as out:
    for line in head:    
        out.write(line)