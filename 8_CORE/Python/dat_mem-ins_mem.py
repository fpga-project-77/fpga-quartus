
# coding: utf-8

# In[1]:


fd = open("matrix.txt", "r")
out = open("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\00 - Git\\fpga-quartus\\Multi_CORE\\MULTI_CORE_edit\\data_mem.txt", "w")
final = open ("final.txt", "w")


# In[2]:


matrix1 = []
matrix2 = []
no_of_cores = 0

matrix1_flag = False
matrix2_flag = False
no_of_core_flag = False

for line in fd:
    final.write(line)
    line1 = line.strip()
    
    if (line1 == "No of Cores:"):
        no_of_core_flag = True
        continue        
    
    if (line1 == "Matrix 1:"):
        matrix1_flag = True
        matrix2_flag = False
        continue

    if (line1 == "Matrix 2:"):
        matrix1_flag = False
        matrix2_flag = True
        continue
        
    if(matrix1_flag):
        matrix1.append(line1.split(","))
    
    if(matrix2_flag):
        matrix2.append(line1.split(","))

    if(no_of_core_flag):
        no_of_cores = int(line1)
        no_of_core_flag = False
print (matrix1)
print (matrix2)


# In[3]:


M = len(matrix1)
N = len(matrix1[0])
K = len(matrix2[0])


# In[4]:


print (M)


# In[5]:


#data
T1 = [0,0,0,0]  #rows for cores
#addresses
T7 = 4  #N
T2 = 5  #M
T4 = 6  #1ST MAT
T3 = T4 + (M*N) + 4  #K
T5 = T3 + 1  #2ND MAT
#T6 = T5 + (K*N) + 1 #3RD MAT


# In[6]:


print (T1)
print (T2)
print (T3)
print (T4)
print (T5)
#print (T6)


# In[7]:


#M = 16
counter = M
#T1 = [0,0,0,0]
#no_of_cores = 4
for i in range (no_of_cores):
    while (counter >= (no_of_cores-i)):
        for j in range(no_of_cores-i):
            T1[j] += 1
            counter -= 1

print (T1)
print ("counter:", counter)
print ("M:", M)
print ("No. of cores:", no_of_cores)


# In[8]:


T4_addr = [0,0,0,0]
T4_addr[0] = T4 + 4
if (no_of_cores > 1):
    T4_addr[1] = T4_addr[0] + T1[0]
if (no_of_cores > 2):    
    T4_addr[2] = T4_addr[1] + T1[1]
if (no_of_cores > 3):    
    T4_addr[3] = T4_addr[2] + T1[2] 


# In[9]:


d_mem_txt = ""

#T1_1
d_mem_txt = d_mem_txt + hex(T1[0])[2:] + "\n"
#T1_2
d_mem_txt = d_mem_txt + hex(T1[1])[2:] + "\n"
#T1_3
d_mem_txt = d_mem_txt + hex(T1[2])[2:] + "\n"
#T1_4
d_mem_txt = d_mem_txt + hex(T1[3])[2:] + "\n"

#M&N of Matrix 1
d_mem_txt = d_mem_txt + hex(M)[2:] + "\n" + hex(N)[2:] + "\n"

#T4_1
d_mem_txt = d_mem_txt + hex(T4_addr[0])[2:] + "\n"
#T4_2
d_mem_txt = d_mem_txt + hex(T4_addr[1])[2:] + "\n"
#T4_3
d_mem_txt = d_mem_txt + hex(T4_addr[2])[2:] + "\n"
#T4_4
d_mem_txt = d_mem_txt + hex(T4_addr[3])[2:] + "\n"

for i in range(N):
    for j in range(M):
        d_mem_txt = d_mem_txt + hex(int(matrix1[j][i]))[2:] + "\n"

d_mem_txt = d_mem_txt + hex(K)[2:] + "\n"

for k in range(K):
    for l in range(N):
        d_mem_txt = d_mem_txt + hex(int(matrix2[l][k]))[2:] + "\n"
#print (d_mem_txt)


# In[10]:


out.write(d_mem_txt.strip())

fd.close()
out.close()


# Instruction Memory

# In[11]:


fd = open("algo.txt", "r")
machine_code = open("D:\\Academic\\ACA\\SEM5 TRONIC ACA\\SEMESTER 5\\CSD\\FPGA\\00 - Git\\fpga-quartus\\Multi_CORE\\MULTI_CORE_edit\\ins_mem.txt", "w")


# In[12]:


comp_dic = {"NOOP": "00", "JPNZM": "10", "JPNZK":"11", "JPNZN":"12", "COPYRm1":"20", "COPYRk1":"21", "COPYRn1":"22",             "COPYRr1":"23", "COPYT4":"24", "LOADC1":"30", "LOADC2":"31", "STORE":"40", "ASSIGNC1":"50", "ASSIGNC2":"51", "RESETALL":"60",             "RESETRn2":"61", "RESETRk2":"62", "RESETRt":"63", "MOVERp":"70", "MOVERt":"71", "MOVEC1":"72", "MOVEC3":"73",             "SETC1":"80", "SETDR":"81", "SETRk1":"82", "MULRp":"90", "MUL_CORE":"9F", "ADDRt":"A0", "ADDRr1":"A1",             "ADDRm2":"A2", "ADD_MEM":"A3", "INCC2":"B0", "INCC3":"B1", "INCRm2":"B2", "INCRk2":"B3", "INCRn2":"B4",             "END":"C0", "CHK_IDLE":"D0", "GET_C1":"E0"}

#rows_per_core starting location in d_mem 
comp_dic["T1"] = "0"
#no_of_rows Matrix 1 (d_mem location)
comp_dic["T7"] = hex(T7)[2:]
#no_of_columns Matrix 1 (d_mem location)
comp_dic["T2"] = hex(T2)[2:]
#no_of_columns Matrix 2 (d_mem location)
comp_dic["T3"] = hex(T3)[2:]
#Starting_point Matrix 1 (d_mem location)
comp_dic["T4"] = hex(T4)[2:]
#Starting_point Matrix 2 (d_mem location)
comp_dic["T5"] = hex(T5)[2:]



# In[13]:


mchine_txt = ""
addr_flag = False
for line in fd:
    line_1 = line.strip()
    #print (line)
    if (addr_flag):
        mchine_txt = mchine_txt + line_1 + "\n"
        addr_flag = False
        continue
    else:
        op_code = comp_dic.get(line_1)
        #print (op_code)
        if (op_code == None):
            continue
        mchine_txt = mchine_txt + op_code + "\n"
    
    if (line_1 == "JPNZM" or line_1 == "JPNZK" or line_1 == "JPNZN"):
        addr_flag = True


# In[14]:


machine_code.write(mchine_txt.strip())
fd.close()
machine_code.close()


# Matrix Multiplication

# In[15]:


new_mat1 = []
new_mat2 = []
for i in matrix1:
    new_mat1.append(list(map(int, i)))
for j in matrix2:
    new_mat2.append(list(map(int, j)))
print (new_mat1)
print (new_mat2)


# In[16]:


import numpy as np

mat1 = np.array(new_mat1)
mat2 = np.array(new_mat2)

final.write("\n" + "\n" + "Multiplied Matrix(From python)" + "\n")
final.write(str(np.matmul(mat1, mat2)))
final.close()

