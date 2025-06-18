s = '(){}[]'
Check = False

for char in range(len(s)):
    if char == '(':
        for i in range(len(s)):
            if i == ')':
                Check = True
            else:
                Check = False
                break
    if char == '[':
        for i in range(len(s)):
            if i == ']':
                Check = True
            else:
                Check = False
                break
    if char == '{':
        for i in range(len(s)):
            if i == '}':
                Check = True
            else:
                Check = False
                break
    return Check