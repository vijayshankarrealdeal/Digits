import pandas as pd 
import numpy as np
from keras.utils import to_categorical
import tensorflow as tf

dataset = pd.read_csv("train.csv")
model_test = pd.read_csv("test.csv").values

x = dataset.iloc[:,1:].values
y = dataset.iloc[:,0].values
from sklearn.model_selection import train_test_split
x_train,x_test,y_train,y_test = train_test_split(x,y,test_size = 0.25) 

x_train= x_train.reshape(len(x_train),28,28,1)
model_test = model_test.reshape(len(model_test),28,28,1)
model_test = model_test/255.0
x_test = x_test.reshape(len(x_test),28,28,1)
#normailize data
x_train = x_train/255.0
x_test = x_test/255.0
y_train = to_categorical(y_train)
y_test = to_categorical(y_test)
print(":>")

from keras.models import Sequential
from keras.layers import Conv2D
from keras.layers import MaxPooling2D
from keras.layers import Flatten
from keras.optimizers import SGD
from keras.layers import Dense

model = Sequential()
model.add(Conv2D(32, (3, 3), activation='relu', kernel_initializer='he_uniform', input_shape=(28, 28, 1)))
model.add(MaxPooling2D((2, 2)))
model.add(Flatten())
model.add(Dense(100, activation='relu', kernel_initializer='he_uniform'))
model.add(Dense(10, activation='softmax'))
	# compile model
model.compile(optimizer=SGD(lr=0.01, momentum=0.9), loss='categorical_crossentropy', metrics=['accuracy'])
model.fit(x_train, y_train, epochs=10, batch_size=32, validation_data=(x_test, y_test), verbose=0)
print(":>")

results = model.predict(model_test)
print(":>")

results = np.argmax(results,axis = 1)
results = pd.Series(results,name="Label")

submission = pd.concat([pd.Series(range(1,28001),name = "ImageId"),results],axis = 1)
submission.to_csv("cnn_mnist_datagen.csv",index=False)
print(":>")


tf.saved_model.save(model, "./models/mnist")
print(":>")

converter = tf.lite.TFLiteConverter.from_saved_model('models/mnist')
print(":>")

tflite_model = converter.convert()
print(":>")

open("models/converted_mnist_model.tflite", "wb").write(tflite_model)
print(":>")