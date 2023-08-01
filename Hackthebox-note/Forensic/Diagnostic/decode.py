

string = ["}", "B{msDt_4s_A_pr0", "E", "r...s", "3Ms_b4D", "l3", "toC", "HT", "0l_h4nD"]
sort = [7, 1, 6, 8, 5, 3, 2, 4, 0]
flag = ""

sorted_string = [string[i] for i in sort]
flag = ''.join(sorted_string)
print(flag)



