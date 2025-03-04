from tkinter import *
root = Tk()
root.geometry("200x250")

upFrame = Frame(root) # Frame은 화면을 여러 구역으로 나눌 때 쓴다.
upFrame.pack()
downFrame = Frame(root)
downFrame.pack()

editBox = Entry(upFrame, width = 10, ) # 엔트리는 입력 상자를 표현한다.
editBox.pack(padx = 20, pady = 20)

listbox = Listbox(downFrame, bg = 'yellow'); # 리스트 박스는 목록을 표현한다.
listbox.pack()

listbox.insert(END, "하나") # END는 데이터를 제일 뒤에 첨부하라는 매개변수다.
listbox.insert(END, "둘")
listbox.insert(END, "셋")

root.mainloop()
