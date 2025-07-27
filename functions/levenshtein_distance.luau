local function LevenshteinDistance(a: string, b: string): number
    local lenA, lenB = #a, #b

    if lenA == 0 then return lenB end
    if lenB == 0 then return lenA end

    local prevRow = {}
    local currRow = {}

    for j = 0, lenB do
        prevRow[j] = j
    end

    for i = 1, lenA do
        currRow[0] = i
        local charA = a:sub(i, i)

        for j = 1, lenB do
            local cost = (charA == b:sub(j, j)) and 0 or 1
            currRow[j] = math.min(
                currRow[j - 1] + 1,      -- insertion
                prevRow[j] + 1,          -- deletion
                prevRow[j - 1] + cost    -- substitution
            )
        end

        prevRow, currRow = currRow, prevRow
    end

    return prevRow[lenB]
end
