# -*- coding: utf-8 -*-
"""
Created on Sat Mar 22 11:43:49 2014

@author: huajun
        @fastml
"""

import sys, csv, math

def sigmoid(x):
	return 1 / (1 + math.exp(-x))
  
def normalize( predictions ):
	s = sum( predictions )
	normalized = []
	for p in predictions:
		normalized.append( p / s )
	return normalized  
  
###  
  
input_file = sys.argv[1]
output_file = sys.argv[2]

i = open( input_file )
o = open( output_file, 'wb' )

reader = csv.reader( i, delimiter = " " )
writer = csv.writer( o )

for line in reader:
	
	# post_id = reader.next()[1]
	
	probs = []
	for element in line:
         try:
		prediction = element.split( ":" )[1]
		prob = sigmoid( float( prediction ))
		probs.append( prob )
         except IndexError:
           post_id = element
           
	new_line = normalize( probs )
        m = max(probs)
        [i for i, j in enumerate(probs) if j == m]
        
	writer.writerow( [post_id] + [i] + new_line )
