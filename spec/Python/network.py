#1
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, Activation, Flatten, Conv2D, MaxPooling2D, BatchNormalization
import numpy as np
import tensorflow.keras as keras
import tensorflow as tf
import pandas as pd
import sys, getopt

class_names = ['T-shirt/top', 'Trouser', 'Pullover', 'Dress', 'Coat',
               'Sandal', 'Shirt', 'Sneaker', 'Bag', 'Ankle boot']
IMG_SIZE = 28
C_SIZE = 32

#3
def conv(size, n, m, p):
  for i in range(size - 2):
    for j in range(size - 2):
      for k in range(3):
        for l in range(3):
          p[i][j] =  p[i][j] + n[i + k][j + l] * m[k][l]
	
def pooling(size, n, p):
  for i in range(size):
    for j in range(size):
      if n[2*i][2*j] > n[2*i][2*j+1]:
        temp = n[2*i][2*j]
      else:
        temp = n[2*i][2*j+1]
      if n[2*i+1][2*j] > n[2*i+1][2*j+1]:
        if temp < n[2*i+1][2*j]:
          temp = n[2*i+1][2*j]
      else:
        if temp < n[2*i+1][2*j+1]:
          temp = n[2*i+1][2*j+1]
      p[i][j] = p[i][j] + temp

def relum(size, n):
  for i in range(size):
    for j in range(size):
      if n[i][j] < 0:
        n[i][j] = 0

def flatten(size, nums, n, f):
  for i in range(nums):
    for j in range(size):
      for k in range(size):
        f.append(n[i][j][k])

def dense(size, f, size2, y, w):
  for i in range(size2):
    for j in range(size):
      y[i] = y[i] + f[j]*w[j][i]

def main(argv):
   inputfile1 = ''
   inputfile2 = ''
   try:
      opts, args = getopt.getopt(argv,"hi:o:",["ifile1=", "ifile2="])
   except getopt.GetoptError:
      print ('network.py -i <inputfile> ')
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print ('network.py -i <inputfile>')
         sys.exit()
      elif opt in ("-i1", "--ifile1"):
         inputfile1 = arg
      elif opt in ("-i2", "--ifile2"):
         inputfile2 = arg   

if __name__ == "__main__":
   main(sys.argv[1:])

file_name = sys.argv[2]
w_file = sys.argv[4]

conv_weights = []  
dense_weights = [] 

weights = pd.read_csv(w_file, delim_whitespace=True, header=None).astype(float).values

for i in range(288):
      conv_weights.append(weights[0][i])
for i in range(288, 54368):
  dense_weights.append(weights[0][i])

conv_weights = np.array(conv_weights).reshape(C_SIZE, 3, 3)
dense_weights = np.array(dense_weights).reshape(32*13*13, 10)

x = []
main(sys.argv[1:])
x = pd.read_csv(file_name, delim_whitespace=True, header=None).astype(float).values
x = x/256.0

for r in range(1):
  
  X = x.reshape(IMG_SIZE,IMG_SIZE)

  #INIT CONV RESULT
  CONV_RES = []
  for i in range(C_SIZE*(IMG_SIZE-2)*(IMG_SIZE-2)):
    CONV_RES.append(0.0)
  CONV_RES = np.array(CONV_RES).reshape(C_SIZE, IMG_SIZE-2, IMG_SIZE-2)

  #INIT POOL RESULT
  POOL_RES = []
  for i in range(C_SIZE*int((IMG_SIZE-2)/2)*int((IMG_SIZE-2)/2)):
    POOL_RES.append(0.0)
  POOL_RES = np.array(POOL_RES).reshape(C_SIZE, int((IMG_SIZE-2)/2), int((IMG_SIZE-2)/2))

  #INIT FLATTENING RESULT
  FLAT = []

  #INIT DENSE RESULT
  FINAL = []
  for i in range(10):
    FINAL.append(0.0)

  #2D LAYERS
  for i in range(C_SIZE):
    conv(IMG_SIZE, X, conv_weights[i], CONV_RES[i])
    pooling(int((IMG_SIZE-2)/2), CONV_RES[i], POOL_RES[i])
    relum(int((IMG_SIZE-2)/2), POOL_RES[i])

  #FLAT LAYERS
  flatten(int((IMG_SIZE-2)/2), C_SIZE, POOL_RES, FLAT)
  dense(int((IMG_SIZE-2)/2)*int((IMG_SIZE-2)/2)*C_SIZE, FLAT, 10, FINAL, dense_weights)
  print(FINAL)
  result = np.argmax(FINAL)
  if result == 0:
    print("Image showed: ", class_names[0])
  elif result == 1:
    print("Image showed: ", class_names[1])
  elif result == 2:
    print("Image showed: ", class_names[2])
  elif result == 3:
    print("Image showed: ", class_names[3])
  elif result == 4:
    print("Image showed: ", class_names[4])
  elif result == 5:
    print("Image showed: ",class_names[5])
  elif result == 6:
    print("Image showed: ",class_names[6])
  elif result == 7:
    print("Image showed: ",class_names[7])
  elif result == 8:
    print("Image showed: ",class_names[8]) 
  elif result == 9:
    print("Image showed: ",class_names[9])
        
