# تصميم قاعدة البيانات - توافقات الأجهزة

## التسلسل
Category -> Brand -> Device -> Part -> Compatibility

## Device
- brand
- model
- model_numbers (مثال SM-... / RMX... / A...)
- aliases
- region / variant لاحقاً

## Part
- category
- name
- part_number
- aliases
- revision
- connector / dimensions لاحقاً

## Compatibility
- target_device
- status
- confidence
- conditions
- sources[]
- verified_by
- verified_at
- notes

## قاعدة الاعتماد
لا يظهر وسم "مؤكد" إلا عند:
- وجود مصدر واضح،
- تسجيل رابط أو مرجع المصدر،
- مراجعة فني،
- عدم وجود تعارض معروف مع نسخة/منطقة الجهاز.
