#!/usr/bin/env bash

printf "\e[34;1m%s\e[0m\n" 'Extracting localisation files'
flutter pub run intl_translation:extract_to_arb --output-dir=lib/app/resources/l10n lib/app/resources/localized_strings.dart

rm lib/app/resources/l10n/intl_en.arb

mv lib/app/resources/l10n/intl_messages.arb lib/app/resources/l10n/intl_en.arb

printf "\e[34;1m%s\e[0m\n" 'Generating localisation files'
flutter pub run intl_translation:generate_from_arb --output-dir=lib/app/resources/l10n --no-use-deferred-loading lib/app/resources/localized_strings.dart lib/app/resources/l10n/intl_*.arb

printf "\e[34;1m%s\e[0m\n" 'Formatting localisation files'
flutter format lib/app/resources/localized_strings.dart
flutter format lib/app/resources/l10n

