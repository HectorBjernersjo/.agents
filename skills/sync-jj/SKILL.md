---
name: sync-jj
description: Använd bara när du blir ombedd
disable-model-invocation: true
---

Dra ner dom senaste ändringarna från master och rebasea våran tweaks-ändring på den, då borde alla andra branches också hänga med.
Om det blir några konflikter så lös dom.
Om något av våra existerande worktrees eller branches ändringar var med i den nya master (alltså att vi troligen har mergeat den), så ska du ta bort det worktreet och den branchen/dom jj-ändringarna.
