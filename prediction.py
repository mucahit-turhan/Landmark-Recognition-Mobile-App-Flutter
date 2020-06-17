# -*- coding: utf-8 -*-

import sys
import numpy as np
import pandas as pd
from keras.preprocessing.image import ImageDataGenerator
from keras.models import load_model
from PIL import Image
import mysql.connector
import os

def main(argv):
    imageName = sys.argv[1]
    script_dir = os.path.dirname(__file__)
    
    subimage_path = "savedimages/"+imageName
    image_path = os.path.join(script_dir, subimage_path)
    
    submodel_path = "model/test3.h5"
    model_path = os.path.join(script_dir, submodel_path)
    
    model = load_model(model_path)
    img = Image.open(image_path)
    img = img.resize((128,128))
    img = np.array(img)
    img = img / 255.0
    img = img.reshape(1,128,128,3)
    pred_probab=model.predict(img)
    result = np.argmax(pred_probab, axis=1)
    
    name = ""
    city = ""
    info = ""
    url = ""
    id = 0
    
    mydb = mysql.connector.connect(
    host="localhost",
    user="myusername",
    password="mypassword",
    database="mydatabase"
    )

    mycursor = mydb.cursor()

    sql = "SELECT * FROM customers WHERE result =" + " result" 

    mycursor.execute(sql)

    myresult = mycursor.fetchall()

    id = myresult[0]
    name = myresult[1]
    city = myresult[2]
    info = myresult[3]
    url = myresult[4]
    
    print(str(id)+"##"+name+"##"+city+"##"+info+"##"+url)
if __name__ == "__main__":
    main(sys.argv[1:])
