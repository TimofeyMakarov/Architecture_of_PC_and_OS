# Это шебанг - подсказывает ОС, где лежит интерпретатор, который надо использовать.
# Shell-скрипты интерпретируются с помощью интерпретатора bash

#!/bin/bash

# Файл, куда будем записывать output программы home1.sh
touch test_output.txt

# Файл, куда будем записывать ненужный output
touch unnecessary_output.txt

# ТЕСТ 1
echo "Test number one is running..."
# Создание папки ограниченного размера
touch FLASH_1
mkdir LIMIT_DIR_1
truncate -s 512M FLASH_1 >> unnecessary_output.txt # Ограничиваем размер файла FLASH_1
mke2fs -t ext4 -F FLASH_1 >> unnecessary_output.txt 2>&1 # Делает из файла FLASH_1 файловую систему типа ext4
sudo mount FLASH_1 LIMIT_DIR_1

# Разрешаем пользователям работать с папкой LIMIT_DIR_1 без sudo
sudo chmod 777 /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_1 >> unnecessary_output.txt

# Создадим файлы и заполним их до размера 24 Мб (примерно 15% от размера папки)
cd LIMIT_DIR_1
touch file1.txt # Должен быть заархивирован
touch file2.txt # Не должен быть заархивирован
touch file3.txt # Не должен быть заархивирован

for((i=0;i<50000;i++))
do
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
done

for((i=1;i<50000;i++))
do
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file3.txt
done

for((i=2;i<50000;i++))
do
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file2.txt
done

cd ..
./home1.sh /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_1 3 >> test_output.txt

if [ ! -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_1/archive.tar.gz ]
then
    echo "Test is failed!"
    exit
fi

if [ ! -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_1/file3.txt ]
then
    echo "Test is failed!"
    exit
fi

if [ ! -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_1/file2.txt ]
then
    echo "Test is failed!"
    exit
fi

if [ -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_1/file1.txt ]
then
    echo "Test is failed!"
    exit
fi

echo "OK"

sudo umount /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_1
rm FLASH_1
rm -r LIMIT_DIR_1

# ТЕСТ 2
echo "Test number two is running..."
# Создание папки ограниченного размера
touch FLASH_2
mkdir LIMIT_DIR_2
truncate -s 512M FLASH_2 >> unnecessary_output.txt # Ограничиваем размер файла FLASH_2
mke2fs -t ext4 -F FLASH_2 >> unnecessary_output.txt 2>&1 # Делает из файла FLASH_2 файловую систему типа ext4
sudo mount FLASH_2 LIMIT_DIR_2

# Разрешаем пользователям работать с папкой LIMIT_DIR_2 без sudo
sudo chmod 777 /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_2 >> unnecessary_output.txt

cd LIMIT_DIR_2
touch file1.txt
touch file2.txt
touch file3.txt

cd ..
./home1.sh /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_2 100 >> test_output.txt

if [ ! -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_2/file1.txt ]
then
    echo "Test is failed!"
    exit
fi

if [ ! -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_2/file2.txt ]
then
    echo "Test is failed!"
    exit
fi

if [ ! -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_2/file3.txt ]
then
    echo "Test is failed!"
    exit
fi

if [ -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_2/archive.tar.gz ]
then
    echo "Test is failed!"
    exit
fi

echo "OK"

sudo umount /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_2
rm FLASH_2
rm -r LIMIT_DIR_2

# ТЕСТ 3
echo "Test number three is running..."
# Создание папки ограниченного размера
touch FLASH_3
mkdir LIMIT_DIR_3
truncate -s 512M FLASH_3 >> unnecessary_output.txt # Ограничиваем размер файла FLASH_3
mke2fs -t ext4 -F FLASH_3 >> unnecessary_output.txt 2>&1 # Делает из файла FLASH_3 файловую систему типа ext4
sudo mount FLASH_3 LIMIT_DIR_3

# Разрешаем пользователям работать с папкой LIMIT_DIR_3 без sudo
sudo chmod 777 /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_3 >> unnecessary_output.txt

cd LIMIT_DIR_3
touch file1.txt # Должен быть заархивирован
mkdir directory1 # Должен быть заархивирован
mkdir directory2 # Не должен быть заархивирован
mkdir directory3 # Не должен быть заархивирован
touch file2.txt # Не должен быть заархивирован

for((i=0;i<50000;i++))
do
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
    echo "$i $i $i $i $i $i $i $i $i $i" >> file1.txt
done

cd directory1
touch file3.txt
for ((j=2;j<50000;j++))
do
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file3.txt
done
cd ..

cd directory2
touch file4.txt
for ((j=3;j<50000;j++))
do
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file4.txt
done
cd ..

cd directory3
touch file5.txt
for ((j=4;j<50000;j++))
do
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file5.txt
done
cd ..

for ((j=1;j<50000;j++))
do
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
    echo "$j $j $j $j $j $j $j $j $j $j" >> file2.txt
done

cd ..
./home1.sh /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_3 0 >> test_output.txt

if [ ! -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_3/archive.tar.gz ]
then
    echo "Test is failed!"
    exit
fi

if [ -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_3/file1.txt ]
then
    echo "Test is failed!"
    exit
fi

if [ -d /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_3/directory1 ]
then
    echo "Test is failed!"
    exit
fi

if [ ! -d /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_3/directory2 ]
then
    echo "Test is failed!"
    exit
fi

if [ ! -d /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_3/directory3 ]
then
    echo "Test is failed!"
    exit
fi

if [ ! -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_3/file2.txt ]
then
    echo "Test is failed!"
    exit
fi

echo "OK"

sudo umount /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_3
rm FLASH_3
rm -r LIMIT_DIR_3

# ТЕСТ 4
echo "Test number four is running..."
# Создание папки ограниченного размера
touch FLASH_4
mkdir LIMIT_DIR_4
truncate -s 512M FLASH_4 >> unnecessary_output.txt # Ограничиваем размер файла FLASH_4
mke2fs -t ext4 -F FLASH_4 >> unnecessary_output.txt 2>&1 # Делает из файла FLASH_4 файловую систему типа ext4
sudo mount FLASH_4 LIMIT_DIR_4

# Разрешаем пользователям работать с папкой LIMIT_DIR_4 без sudo
sudo chmod 777 /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_4 >> unnecessary_output.txt

# Заархивируется только один каталог lost+found
./home1.sh /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_4 0 >> test_output.txt

if [ ! -f /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_4/archive.tar.gz ]
then
    echo "Test is failed!"
    exit
fi

echo "OK"

sudo umount /mnt/c/Users/Тимофей/homeworks/LIMIT_DIR_4
rm FLASH_4
rm -r LIMIT_DIR_4

# ТЕСТ 5
echo "Test number five is running..."
./home1.sh privet 30 >> test_output.txt

if [ "$(tail -n 1 test_output.txt)" != "Path is not correct" ]
then
    echo "Test is failed!"
    exit
fi

echo "Ok"

# ТЕСТ 6
echo "Test number six is running..."
./home1.sh hello higher school of economic >> test_output.txt

if [ "$(tail -n 1 test_output.txt)" != "The input arguments are incorrect" ]
then
    echo "Test is failed!"
    exit
fi

echo "Ok"

# ТЕСТ 7
echo "Test number seven is running..."
./home1.sh /mnt/c/Users/Тимофей seventy >> test_output.txt

if [ "$(tail -n 1 test_output.txt)" != "Parameter is not a number" ]
then
    echo "Test is failed!"
    exit
fi

echo "Ok"

rm test_output.txt
rm unnecessary_output.txt
