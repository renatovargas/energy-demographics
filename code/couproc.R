# couproc.R
# Procesar los COU de Guatemala automáticamente 
# (Process Guatemalan Supply and Use tables)
# Renato Vargas (renovargas@gmail.com)
# Todos los derechos reservados, Renato Vargas, 2015.

library(reshape)
library(xlsx)

setwd("/data/couproc/")
rm(list = ls())

if(!file.exists("data")){dir.create("data")}
fileUrl <- "www.naturalcapitalworld.com/data/COU-2010-test.xlsx"
download.file(fileUrl, destfile="./data/COU-2010.xlsx", method="curl")
dateDownloaded <- date()


# 1. Cuadro de oferta / Supply table
# ==================================

# Nombre de las columnas / Get the column names

# uso read.xlsx y al mismo tiempo obtengo como lista con as.list la primera columna [,1] de la matriz resultante / use read.xlsx and at the same time turn to list, indexing by the first column [,1] of the resulting matrix

colNames <- as.vector(t(read.xlsx2("./data/COU-2010.xlsx", sheetIndex=1, header=FALSE, startRow=18, endRow=18, colIndex= c(3:165))[1,]))

# Nombre de las filas / Get the row names
#rowNames <- as.vector((read.xlsx2("./data/COU-2010.xlsx", sheetIndex=1, header=FALSE, startRow=19, endRow=314, colIndex= c(1:2)))[,1])
rowNames <- as.vector((read.xlsx2("./data/COU-2010.xlsx", sheetIndex=1, header=FALSE, startRow=328, endRow=623, colIndex= c(1:2)))[,1])

# Ahora el Cuadro de oferta con totales / Supply table as is
supplyTable <- as.data.frame(read.xlsx2("./data/COU-2010.xlsx", sheetIndex=1, header=FALSE, startRow=19, endRow=314, colIndex= c(1:165), stringsAsFactors=FALSE, colClasses= c("character","character", rep("numeric", 163))))
colnames(supplyTable) <- c("Codigo", "Producto",colNames)
#rownames(supplyTable) <- rowNames

# Extraer columnas y filas relevantes / extract relevant columns and rows
#colsYES <- -c(130, 134, 148, 149, 150, 153, 155, 159, 164, 165)
supplyTable <- supplyTable[c(nchar(rownames(supplyTable)) == 4),-c(130, 134, 148, 149, 150, 153, 155, 159, 164, 165)]

# Convertir de tabla de doble entrada a Flat File / From pivot table to flat file
newcolnames <- colnames(supplyTable)[c(3:dim(supplyTable)[2])]
supplyFlatFile <- melt.data.frame(supplyTable, id.vars=c(1,2), na.rm=FALSE)
supplyFlatFile$Ofut <- "Oferta"
# supplyFlatFile$Codigo <- as.character(supplyFlatFile$Codigo)
# supplyFlatFile$value <- as.numeric(supplyFlatFile$value)

# Mostramos el resultado / show resulting table
head(supplyFlatFile)


# 2. Cuadro de utilizacion / Use table
# ====================================

colNames <- as.vector(t(read.xlsx2("./data/COU-2010.xlsx", sheetIndex=1, header=FALSE, startRow=327, endRow=327, colIndex= c(3:164))[1,]))

# Nombre de las filas / Get the row names
#rowNames <- as.vector((read.xlsx2("./data/COU-2010.xlsx", sheetIndex=1, header=FALSE, startRow=328, endRow=623, colIndex= c(1:2)))[,1])

# Ahora el Cuadro de utilizacion con totales / Use table as is
useTable <- as.data.frame(read.xlsx2("./data/COU-2010.xlsx", sheetIndex=1, header=FALSE, startRow=328, endRow=623, colIndex= c(1:164), stringsAsFactors=FALSE, colClasses= c("character","character", rep("numeric", 162))))
colnames(useTable) <- c("Codigo", "Producto",colNames)
#rownames(useTable) <- rowNames

# Extraer columnas y filas relevantes / extract relevant columns and rows
#colsYES <- -c(130, 134, 148, 149, 150, 153, 158, 159, 163, 164)
useTable <- useTable[c(nchar(rownames(useTable)) == 4),-c(130, 134, 148, 149, 150, 153, 158, 159, 163,164)]

# Convertir de tabla de doble entrada a Flat File / From pivot table to flat file
newcolnames <- colnames(useTable)[c(3:dim(useTable)[2])]
useFlatFile <- melt.data.frame(useTable, id.vars=c(1,2), na.rm=FALSE)
useFlatFile$Ofut <- "Utilizacion"
# useFlatFile$value <- as.numeric(useFlatFile$value)

# Mostramos el resultado / show resulting table
head(useFlatFile)
useFlatFile$Codigo <- as.character(useFlatFile$Codigo)


# 3. Unimos las dos tablas para obtener el cuadro total / We join the two tables
# ===========
supplyUse <- rbind(supplyFlatFile,useFlatFile)
#supplyUse$value <- as.numeric(supplyUse$value)
colnames(supplyUse) <- c("npg","prod","col","val", "ofut")
write.xlsx2(supplyUse, "./data/cou.xlsx", sheetName="COU", col.names=TRUE, row.names=FALSE, append=FALSE)

write.csv(supplyUse, "./data/cou.csv", quote=TRUE, fileEncoding="Latin1")
rm(list = ls())

