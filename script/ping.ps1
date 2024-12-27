# Set the target IPv4 address
$target = "8.8.8.8"

# Ping the target and check the result
if (Test-Connection -ComputerName $target -Count 1 -Quiet) {
    Write-Output "win"
} else {
    Write-Output "fail"
}