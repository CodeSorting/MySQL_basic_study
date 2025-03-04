from tkinter import *
root = Tk()

button1 = Button(root, text="혼공1")
button2 = Button(root, text="혼공2")
button3 = Button(root, text="혼공3")

button1.pack(side=LEFT) # 가로로 정렬하는 법은 LEFT,RIGHT가 있다. LEFT는 왼쪽부터, RIGHT는 오른쪽부터 채운다.
button2.pack(side=LEFT) # TOP,BOTTOM은 위, 아래부터 채운다.
button3.pack(side=LEFT)

root.mainloop()
