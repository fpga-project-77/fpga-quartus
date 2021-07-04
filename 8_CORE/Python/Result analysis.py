
# coding: utf-8

# In[1]:


from ast import literal_eval


# In[2]:


final = open ("final.txt", "a")
result = open ("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\00 - Git\\fpga-quartus\\Multi_CORE\\MULTI_CORE_edit\\result.txt", "r")
d_mem = open ("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\00 - Git\\fpga-quartus\\Multi_CORE\\MULTI_CORE_edit\\data_mem.txt", "r")


# In[3]:


core_1_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_2_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_3_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_4_rows = int(literal_eval('0x' + d_mem.readline().strip()))
core_rows = [core_1_rows, core_2_rows, core_3_rows, core_4_rows]
M = int(literal_eval('0x' + d_mem.readline().strip()))
N = int(literal_eval('0x' + d_mem.readline().strip()))


# In[4]:


mem_start_core_1 = 127 + 3
mem_start_core_4 = 159 + 3
mem_start_core_2 = 191 + 3
mem_start_core_3 = 223 + 3


# In[5]:


count = 0
matt = []
row = []
for i in result:
    if (core_2_rows == core_3_rows == core_4_rows == 0):
        if((mem_start_core_1 <= count < 255) and (i != "xx\n")):
            x = '0x' + i.strip()
            row.append(literal_eval(x))
    elif ((core_1_rows >= 1 and core_2_rows >= 1) and (core_3_rows == core_4_rows == 0)):
        if((mem_start_core_1 <= count < mem_start_core_2) and (i != "xx\n")):
            x = '0x' + i.strip()
            row.append(literal_eval(x)) 
        if (count == mem_start_core_2):
            matt.append(row)
            row = []
        if((mem_start_core_2 <= count < 255) and (i != "xx\n")):
            x = '0x' + i.strip()
            row.append(literal_eval(x))
    else:
        if((mem_start_core_1 <= count < mem_start_core_4) and (i != "xx\n")):             #core1
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_4):
            matt.append(row)
            row = []

        if((mem_start_core_4 <= count < mem_start_core_2) and (i != "xx\n")):             #core4
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_2):
            matt.append(row)
            row = []

        if((mem_start_core_2 <= count < mem_start_core_3) and (i != "xx\n")):              #core2
            x = '0x' + i.strip()
            row.append(literal_eval(x))
        if (count == mem_start_core_3):
            matt.append(row)
            row = []

        if((mem_start_core_3 <= count) and (i != "xx\n")):                                #core3
            x = '0x' + i.strip()
            row.append(literal_eval(x))
    if (count == 255):
        matt.append(row)
        row = []
    count += 1
    
print (matt)
if(core_1_rows >= 1 and core_2_rows >= 1 and (core_3_rows >=1 or core_4_rows >= 1)):
    matt = [matt[0], matt[2], matt[3], matt[1]]


# In[6]:


#matt = [[55, 35, 115,35, 55, 95,55, 35, 115]]
#core_rows = [3,0,0,0]

final_mat = []
print (core_rows)
for j in range(4):
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


# In[7]:


final.write("\n" + "\n" + "Multiplied Matrix(From FPGA)" + "\n")
for i in final_mat:
    final.write(str(i)) 
    final.write("\n")
final.close()

