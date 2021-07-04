M = 5
counter = M
T1 = [0,0,0,0]
no_of_cores = 4
for i in range (no_of_cores):
	while (counter >= (no_of_cores-i)):
		for j in range(no_of_cores-i):
			T1[j] += 1
			counter -= 1

print (T1)
print ("counter:", counter)
print ("M:", M)
print ("No. of cores:", no_of_cores)
