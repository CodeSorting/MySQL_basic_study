from tkinter import *
from tkinter import messagebox

def clickButton() :
    messagebox.showinfo('버튼 클릭', '버튼을 눌렀습니다..')

root = Tk()
root.geometry("200x200")

button1 = Button(root, text="여기를 클릭하세요", fg="red", bg="yellow", command=clickButton) # Button(부모윈도,옵션...)
button1.pack(expand = 1) # 화면 중앙에 위치하기 위해 expand=1로 놓음.

root.mainloop()
