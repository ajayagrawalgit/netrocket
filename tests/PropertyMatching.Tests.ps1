Describe "NetRocket property matching" {
    BeforeAll {
        function Find-AdvancedProperties {
            param(
                [Parameter(Mandatory)][object[]]$Properties,
                [Parameter(Mandatory)][string[]]$Patterns
            )

            $matches = foreach ($pattern in $Patterns) {
                $Properties | Where-Object { $_.DisplayName -match $pattern }
            }

            @($matches | Sort-Object DisplayName -Unique)
        }
    }

    It "matches exact property names" {
        $properties = @(
            [pscustomobject]@{ DisplayName = "Interrupt Moderation"; DisplayValue = "Enabled" }
            [pscustomobject]@{ DisplayName = "Flow Control"; DisplayValue = "Rx & Tx" }
        )

        $result = @(Find-AdvancedProperties $properties @("^Interrupt Moderation$"))

        $result.Count | Should -Be 1
        $result[0].DisplayName | Should -Be "Interrupt Moderation"
    }

    It "matches broader driver-property patterns" {
        $properties = @(
            [pscustomobject]@{ DisplayName = "Energy Efficient Ethernet"; DisplayValue = "Enabled" }
        )

        $result = @(Find-AdvancedProperties $properties @("Energy Efficient"))

        $result.Count | Should -Be 1
    }

    It "deduplicates overlapping patterns" {
        $properties = @(
            [pscustomobject]@{ DisplayName = "Flow Control"; DisplayValue = "Disabled" }
        )

        $result = @(Find-AdvancedProperties $properties @("^Flow Control$","Flow Control"))

        $result.Count | Should -Be 1
    }

    It "returns nothing when a setting is unavailable" {
        $properties = @(
            [pscustomobject]@{ DisplayName = "Jumbo Packet"; DisplayValue = "Disabled" }
        )

        $result = @(Find-AdvancedProperties $properties @("^Interrupt Moderation$"))

        $result.Count | Should -Be 0
    }
}
