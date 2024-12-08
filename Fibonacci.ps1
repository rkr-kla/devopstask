param (
    [int]$n
)


function CalcFibonacci {
    param (
        [Parameter(Mandatory=$true)]
        [int]$Index
    )

    if ($Index -le 0) {
        return 0
    } elseif ($Index -eq 1) {
        return 1
    } else {
        # calc Fibonacci-Number (iterativ)
        $a = 0
        $b = 1
        for ($i = 2; $i -le $Index; $i++) {
            $temp = $a + $b
            $a = $b
            $b = $temp
        }
        return $b
    }
}

if ($PSBoundParameters.ContainsKey('n')) {
    # Mode: single Fibonacci numberfor index $n
    Write-Host "Fibonacci($n): $(CalcFibonacci -Index $n)"
} else {
    # Mode: all fibonacci numbers, one each 0.5 seconds
    $index = 0
    while ($true) {
        $fib = CalcFibonacci -Index $index            
        Write-Host "Fibonacci($index): $fib"
        Start-Sleep -Milliseconds 500
        $index++
    }
}