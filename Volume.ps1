$obj = New-Object -ComObject WScript.Shell

# First, mute then unmute to reset, or just turn down 50 times (each tick is 2%)
# to ensure we start at 0% volume.
for ($i = 0; $i -lt 50; $i++) {
    $obj.SendKeys([char]174) # 174 is the Virtual Key Code for Volume Down
}

# Now increase by one "tick" (approx 2%)
#$obj.SendKeys([char]175) # 175 is the Virtual Key Code for Volume Up

for ($o = 0; $o -lt 2; $o++) {
    $obj.SendKeys([char]175) # 174 is the Virtual Key Code for Volume Down
}
