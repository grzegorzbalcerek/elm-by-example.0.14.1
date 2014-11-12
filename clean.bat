@echo off
del *.exe
del *.hi
del *.o
rmdir /q/s target
rmdir /q/s code\build
rmdir /q/s code\cache
rmdir /q/s build
rmdir /q/s cache
