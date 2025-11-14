import os
base_dir = 'PA-KB'

train_dir = os.path.join(base_dir, 'TRAIN')
test_dir = os.path.join(base_dir, 'TEST')

train_o_dir = os.path.join(train_dir, 'O') # Organik
train_r_dir = os.path.join(train_dir, 'R') # Non-organik (Recycle)
test_o_dir = os.path.join(test_dir, 'O')
test_r_dir = os.path.join(test_dir, 'R')

import tensorflow as tf
from tensorflow.keras.preprocessing.image import ImageDataGenerator
import matplotlib.pyplot as plt
import numpy as np
from tensorflow.keras.preprocessing.image import load_img, img_to_array
if os.path.exists(base_dir):
    print("\n--- Data Collecting ---")
    print("Jumlah data training organik (O):", len(os.listdir(train_o_dir)))
    print("Jumlah data training non-organik (R):", len(os.listdir(train_r_dir)))
    print("Total data training:", len(os.listdir(train_o_dir)) + len(os.listdir(train_r_dir)))
    print("-" * 20)
    print("Jumlah data test organik (O):", len(os.listdir(test_o_dir)))
    print("Jumlah data test non-organik (R):", len(os.listdir(test_r_dir)))
    print("Total data test:", len(os.listdir(test_o_dir)) + len(os.listdir(test_r_dir)))
else:
    print("\nSilakan perbaiki 'base_dir' di sel sebelumnya terlebih dahulu.")

IMAGE_SIZE = (100, 100)
#coba ubah batch sizenya dibesarkan contoh 64
BATCH_SIZE = 64

train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=40,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,
    fill_mode='nearest'
)

test_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow_from_directory(
    train_dir,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='binary'
)

validation_generator = test_datagen.flow_from_directory(
    test_dir,
    target_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    class_mode='binary'
)

print("\nLabel kelas yang ditemukan:")
print(train_generator.class_indices)


def show_sample_images(directory, class_name, title):
    plt.figure(figsize=(10, 3))
    plt.suptitle(title, fontsize=16)

    img_files = np.random.choice(os.listdir(os.path.join(directory, class_name)), 5, replace=False)

    for i, file_name in enumerate(img_files):
        img_path = os.path.join(directory, class_name, file_name)
        img = load_img(img_path, target_size=IMAGE_SIZE)

        plt.subplot(1, 5, i+1)
        plt.imshow(img)
        plt.title(class_name)
        plt.axis('off')
    plt.show()

print("Contoh Gambar Organik (O) dari Data Training:")
show_sample_images(train_dir, 'O', "Contoh Data Organik (O)")

print("\nContoh Gambar Non-Organik (R) dari Data Training:")
show_sample_images(train_dir, 'R', "Contoh Data Non-Organik (R)")