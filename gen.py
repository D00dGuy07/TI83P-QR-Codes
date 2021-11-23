import qrcode
import math

CALC_WIDTH = 96
CALC_HEIGHT = 64
LINK = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

def getBounds(width, height):
	leftOff = width / 2
	rightOff = leftOff
	topOff = height / 2
	bottomOff = topOff
	if (width % 2 == 1):
		leftOff += 0.5
		rightOff -= 0.5
	if (height % 2 == 1):
		topOff += 0.5
		bottomOff -= 0.5

	return CALC_WIDTH / 2 - leftOff * 2, CALC_HEIGHT / 2 - topOff * 2, CALC_WIDTH / 2 + rightOff * 2, CALC_HEIGHT / 2 + bottomOff * 2

def main():
	img = qrcode.make()
	qr = qrcode.QRCode(
		version=3,
		error_correction=qrcode.constants.ERROR_CORRECT_L,
		box_size=1,
		border=0,
	)
	qr.add_data(LINK)
	qr.make(fit=False)

	img = qr.make_image(fill_color="black", back_color="white")

	width, height = img.size
	left, top, right, bottom = getBounds(width, height)

	cCode = "char buf[] = {"
	currentByte = []
	for y in range(CALC_HEIGHT):
		cCode += "\n\t"
		for x in range(CALC_WIDTH):
			if x >= left and x < right and y >= top and y < bottom:
				b = img.getpixel((math.floor((x - left) / 2), math.floor((y - top) / 2)))
				if b == 0:
					currentByte.append(True)
				else:
					currentByte.append(False)
			else:
				currentByte.append(False)

			if len(currentByte) == 8:
				encoded = 0
				for i in range(8):
					encoded |= (128 >> i) if currentByte[i] == True else 0
				currentByte.clear()
				encodedString = "0x" + format(encoded, "02x")

				if x == CALC_WIDTH - 1 and y == CALC_HEIGHT - 1:
					cCode += encodedString + '\n'
				elif x == CALC_WIDTH - 1:
					cCode += encodedString + ",\t"
				else:
					cCode += encodedString + ", "
	cCode += "};"

	print(cCode)

			


if __name__ == "__main__":
	main()