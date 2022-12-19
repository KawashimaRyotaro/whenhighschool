#include <SPI.h>
#include <SD.h>
Sd2Card card;
SdVolume volume;
SdFile root;
const int chipSelect = 10;
void setup()
{
Serial.begin(38400);
while (!Serial) {
; // wait for serial port to connect. Needed for Leonardo only
}
Serial.print("\nInitializing SD card...");
pinMode(10, OUTPUT); // change this to 53 on a mega
if (!card.init(SPI_HALF_SPEED, chipSelect)) {
Serial.println("initialization failed. Things to check:");
Serial.println("* is a card is inserted?");
Serial.println("* Is your wiring correct?");
Serial.println("* did you change the chipSelect pin to match your shield or module?");
return;
} else {
Serial.println("Wiring is correct and a card is present.");
}
Serial.print("\nCard type: ");
switch (card.type()) {
case SD_CARD_TYPE_SD1:
Serial.println("SD1");
break;
case SD_CARD_TYPE_SD2:
Serial.println("SD2");
break;
case SD_CARD_TYPE_SDHC:
Serial.println("SDHC");
break;
default:
Serial.println("Unknown");
}
if (!volume.init(card)) {
Serial.println("Could not find FAT16/FAT32 partition.\nMake sure you've formatted the card");
return;
}
uint32_t volumesize;
Serial.print("\nVolume type is FAT");
Serial.println(volume.fatType(), DEC);
Serial.println();
volumesize = volume.blocksPerCluster(); // clusters are collections of blocks
volumesize *= volume.clusterCount(); // we'll have a lot of clusters
volumesize *= 512; // SD card blocks are always 512 bytes
Serial.print("Volume size (bytes): ");
Serial.println(volumesize);
Serial.print("Volume size (Kbytes): ");
volumesize /= 1024;
Serial.println(volumesize);
Serial.print("Volume size (Mbytes): ");
volumesize /= 1024;
Serial.println(volumesize);
Serial.println("\nFiles found on the card (name, date and size in bytes): ");
root.openRoot(volume);
root.ls(LS_R | LS_DATE | LS_SIZE);
}
void loop(void) {}
