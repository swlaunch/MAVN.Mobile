#!/usr/bin/env bash

flutter pub run intl_translation:extract_to_arb --output-dir=lib/app/resources/l10n lib/app/resources/localized_strings.dart

rm lib/app/resources/l10n/intl_en.arb

mv lib/app/resources/l10n/intl_messages.arb lib/app/resources/l10n/intl_en.arb

flutter pub run intl_translation:generate_from_arb --output-dir=lib/app/resources/l10n --no-use-deferred-loading lib/app/resources/localized_strings.dart lib/app/resources/l10n/intl_*.arb

flutter format .

git add .
git checkout -b chore/update_english_localisations
git commit -m "Updated english localisation file" --no-verify
git push --set-upstream origin chore/update_english_localisations

open https://bitbucket.org/lykkemavn/lykke.mobile.mavn/pull-requests/new?source=chore/update_english_localisations&t=1

