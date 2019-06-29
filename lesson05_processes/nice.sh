#!/usr/bin/env bash
lownice() {
  echo "`date` Запускаем скрипт с низким приоритетом\n" >> nice.log
  nice -n 19 dd if=/dev/zero of=/data/test.log bs=1M count=10000 status=progress oflag=direct  > /dev/null 2>&1
  echo "`date` Скрипт с низким приоритетом завершен\n" >> nice.log
}

hinice() {
  echo "`date` Запускаем скрипт с высоким приоритетом\n" >> nice.log
  nice -n -19 dd if=/dev/zero of=/data/test1.log bs=1M count=10000 status=progress oflag=direct > /dev/null 2>&1
  echo "`date` Скрипт с высоким приоритетом завершен\n" >> nice.log
}

lownice &
hinice &
