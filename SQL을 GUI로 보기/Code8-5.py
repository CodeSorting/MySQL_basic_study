from tkinter import *
root = Tk()
root.geometry("300x100")

label1 = Label(root, text="혼공 SQL은") # Label() = 문자를 표현할 수 있는 위젯,위젯은 윈도우에 나오는 버튼,텍스트,라디오 버튼, 이미지등을 통합해서 지칭하는 용어다.
label2 = Label(root, text="쉽습니다.", font=("궁서체", 30), bg="blue", fg="yellow")

label1.pack() # pack()을 써야 화면에 나타난다.
label2.pack()

root.mainloop()
