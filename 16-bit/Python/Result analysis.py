
# coding: utf-8

# In[91]:


from ast import literal_eval


# In[92]:


final = open ("final.txt", "a")
result = open ("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\00 - Git\\fpga-quartus\\16-bit\\MULTI_CORE_edit\\result.txt", "r")
d_mem = open ("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\00 - Git\\fpga-quartus\\16-bit\\MULTI_CORE_edit\\data_mem.txt", "r")


# In[93]:


core_1_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_2_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_3_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_4_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_5_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_6_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_7_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_8_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_rows = [core_1_rows, core_2_rows, core_3_rows, core_4_rows, core_5_rows, core_6_rows, core_7_rows, core_8_rows]
M = int(literal_eval('0x' + d_mem.readline().strip()))
N = int(literal_eval('0x' + d_mem.readline().strip()))


# In[94]:


mem_start_core_1 = 1023 + 3
mem_start_core_8 = 1151 + 3
mem_start_core_4 = 1279 + 3
mem_start_core_5 = 1407 + 3
mem_start_core_2 = 1535 + 3
mem_start_core_7 = 1663 + 3
mem_start_core_3 = 1791 + 3
mem_start_core_6 = 1919 + 3


# In[95]:


count = 0
matt = []
row = []
for i in result:
    if (core_2_rows == core_3_rows == core_4_rows == 0):
        if((mem_start_core_1 <= count < 255) and (i != "xxxx\n")):
            x = '0x' + i.strip()
            row.append(literal_eval(x))
    elif ((core_1_rows >= 1 and core_2_rows >= 1) and (core_3_rows == core_4_rows == 0)):
        if((mem_start_core_1 <= count < mem_start_core_2) and (i != "xxxx\n")):
            x = '0x' + i.strip()
            row.append(literal_eval(x)) 
        if (count == mem_start_core_2):
            matt.append(row)
            row = []
        if((mem_start_core_2 <= count < 255) and (i != "xxxx\n")):
            x = '0x' + i.strip()
            row.append(literal_eval(x))
    else:
        if((mem_start_core_1 <= count < mem_start_core_8) and (i != "xxxx\n")):             #core1
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_8):
            matt.append(row)
            row = []
        if((mem_start_core_8 <= count < mem_start_core_4) and (i != "xxxx\n")):             #core8
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_4):
            matt.append(row)
            row = []
        if((mem_start_core_4 <= count < mem_start_core_5) and (i != "xxxx\n")):             #core4
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_5):
            matt.append(row)
            row = []
        if((mem_start_core_5 <= count < mem_start_core_2) and (i != "xxxx\n")):             #core5
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_2):
            matt.append(row)
            row = []
        if((mem_start_core_2 <= count < mem_start_core_7) and (i != "xxxx\n")):             #core2
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_7):
            matt.append(row)
            row = []
        if((mem_start_core_7 <= count < mem_start_core_3) and (i != "xxxx\n")):              #core7
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_3):
            matt.append(row)
            row = []
        if((mem_start_core_3 <= count < mem_start_core_6) and (i != "xxxx\n")):             #core3
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_6):
            matt.append(row)
            row = []
        if((mem_start_core_6 <= count) and (i != "xxxx\n")):                                #core6
            x = '0x' + i.strip()
            row.append(literal_eval(x))
    if (count == 2047):
        matt.append(row)
        row = []
    count += 1
    
print (matt)
if(core_1_rows >= 1 and core_2_rows >= 1 and (core_3_rows >=1 or core_4_rows >= 1)):
    matt = [matt[0], matt[4], matt[6], matt[2], matt[3], matt[7], matt[5], matt[1]]


# In[96]:


print (matt)


# In[97]:


#matt = [[55, 35, 115,35, 55, 95,55, 35, 115]]
#core_rows = [3,0,0,0]

final_mat = []
print (core_rows)
for j in range(8):
    if(core_rows[j] > 1):
        l = len(matt[j])
        print(l)
        no_per_row = int(l/core_rows[j])
        print (no_per_row)
        counter = 0
        while (counter != l):
            row = []
            for i in range(no_per_row):
                row.append(matt[j][counter])
                counter +=1
            final_mat.append(row)
            #counter += no_per_row
    elif (core_rows[j] == 1):
        final_mat.append(matt[j])
print (final_mat)


# In[90]:


final.write("\n" + "\n" + "Multiplied Matrix(From FPGA)" + "\n")
for i in final_mat:
    final.write(str(i)) 
    final.write("\n")
final.close()

