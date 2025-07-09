# FakeNFT 27_1

Swift 5.10, UIKit, SnapKit

🛠️ Инструменты
Установите необходимые инструменты:
```
brew install xcodegen
brew install swiftlint
brew install swiftformat
```

🚀 Начало работы
1. Клонирование репозитория
```
git clone https://github.com/resxton/FakeNFT.git
```
2. Настройки Git hooks
```
git config core.hooksPath .githooks
```
3. Переходим в `bash`, если оболочка не `bash`:
```
bash
```
4. Выполняем команду и вводим свой токен:
```bash
read -r -p "Enter your API token: " token && printf 'API_TOKEN = %s\n' "$token" > Secrets.xcconfig && echo "✅ Secrets.xcconfig sucessfully created!"
```
5. Генерация Xcode проекта
```
xcodegen generate
```

🧰 Инструменты разработки
1. XcodeGen
```
xcodegen generate
```
2. SwiftFormat
```
# Форматирование всего проекта
swiftformat .
```
3. SwiftLint
```
# Проверка всего проекта
swiftlint
```
