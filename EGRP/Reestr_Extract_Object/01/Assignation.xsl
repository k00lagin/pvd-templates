<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="GetAssignationName">
		<xsl:param name="AssignationCode"/>
		<xsl:choose>
			<xsl:when test="$AssignationCode='005001000000'">
				<xsl:value-of select="'Жилое'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005001000000'">
				<xsl:value-of select="'Жилое'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005001001000'">
				<xsl:value-of select="'Постоянного проживания'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005001001001'">
				<xsl:value-of select="'Общежитие'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005001002000'">
				<xsl:value-of select="'Временного проживания'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002000000'">
				<xsl:value-of select="'Нежилое'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001000'">
				<xsl:value-of select="'Общественное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001001'">
				<xsl:value-of select="'Административно-управленческое'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001002'">
				<xsl:value-of select="'Народного образования'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001003'">
				<xsl:value-of select="'Науки и научного обслуживания'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001004'">
				<xsl:value-of select="'Здравоохранения, физической культуры и социального обеспечения'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001005'">
				<xsl:value-of select="'Торговли и общественного питания'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001006'">
				<xsl:value-of select="'Коммунально-бытового обслуживания'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001007'">
				<xsl:value-of select="'Культуры и искусства'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001008'">
				<xsl:value-of select="'Отдыха и развлечений'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001009'">
				<xsl:value-of select="'Финансирования и страхования'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001010'">
				<xsl:value-of select="'Городского благоустройства'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001011'">
				<xsl:value-of select="'Дачно-садоводческое'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001012'">
				<xsl:value-of select="'Гаражное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001013'">
				<xsl:value-of select="'Культовое'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001014'">
				<xsl:value-of select="'Ритуальное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002001015'">
				<xsl:value-of select="'Не определено'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002000'">
				<xsl:value-of select="'Производственное (промышленное)'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002001'">
				<xsl:value-of select="'Электроэнергетики'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002002'">
				<xsl:value-of select="'Топливной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002003'">
				<xsl:value-of select="'Черной металлургии'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002004'">
				<xsl:value-of select="'Цветной металлургии'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002005'">
				<xsl:value-of select="'Химической и нефтехимической промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002006'">
				<xsl:value-of select="'Химико-фармацевтической промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002007'">
				<xsl:value-of select="'Тяжелого машиностроения'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002008'">
				<xsl:value-of select="'Станкостроительной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002009'">
				<xsl:value-of select="'Автотракторной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002010'">
				<xsl:value-of select="'Легкого машиностроения и бытовых приборов'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002011'">
				<xsl:value-of select="'Электротехнической, приборостроительной и радиопромышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002012'">
				<xsl:value-of select="'Судостроительной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002013'">
				<xsl:value-of select="'Авиационной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002014'">
				<xsl:value-of select="'Межотраслевых производств машиностроения'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002015'">
				<xsl:value-of select="'Лесозаготовительной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002016'">
				<xsl:value-of select="'Деревообрабатывающей промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002017'">
				<xsl:value-of select="'Целлюлозно-бумажной и лесохимической промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002018'">
				<xsl:value-of select="'Промышленности строительных материалов'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002019'">
				<xsl:value-of select="'Стекольной и фарфорофаянсовой промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002020'">
				<xsl:value-of select="'Полиграфического производства'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002021'">
				<xsl:value-of select="'Текстильной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002022'">
				<xsl:value-of select="'Швейной, кожевенной, меховой, обувной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002023'">
				<xsl:value-of select="'Пищевкусовой промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002024'">
				<xsl:value-of select="'Мясной и молочной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002025'">
				<xsl:value-of select="'Рыбоперерабатывающей и плодоовощной промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002026'">
				<xsl:value-of select="'Микробиологической промышленности'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002027'">
				<xsl:value-of select="'Строительной индустрии'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002002028'">
				<xsl:value-of select="'Не определено'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002003000'">
				<xsl:value-of select="'Транспортное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002003001'">
				<xsl:value-of select="'Железнодорожного транспорта'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002003002'">
				<xsl:value-of select="'Автомобильного транспорта'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002003003'">
				<xsl:value-of select="'Водного транспорта'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002003004'">
				<xsl:value-of select="'Воздушного транспорта'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002003005'">
				<xsl:value-of select="'Городского надземного электротранспорта'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002003006'">
				<xsl:value-of select="'Городского подземного транспорта'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002003007'">
				<xsl:value-of select="'Магистрального трубопроводного транспорта'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002004000'">
				<xsl:value-of select="'Сельскохозяйственное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002005000'">
				<xsl:value-of select="'Лесного хозяйства'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002006000'">
				<xsl:value-of select="'Рыбного хозяйства'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002007000'">
				<xsl:value-of select="'Добычи полезных ископаемых'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002008000'">
				<xsl:value-of select="'Строительное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002009000'">
				<xsl:value-of select="'Связи'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002010000'">
				<xsl:value-of select="'Материально-технического снабжения и сбыта'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002011000'">
				<xsl:value-of select="'Гидротехническое'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002012000'">
				<xsl:value-of select="'Водохозяйственное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002013000'">
				<xsl:value-of select="'Передаточное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002013001'">
				<xsl:value-of select="'Электропередачи'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002013002'">
				<xsl:value-of select="'Теплопередачи'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002013003'">
				<xsl:value-of select="'Водопередачи'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002014000'">
				<xsl:value-of select="'Городского коммунального хозяйства'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002014001'">
				<xsl:value-of select="'Электроснабжения'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002014002'">
				<xsl:value-of select="'Теплоснабжения'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002014003'">
				<xsl:value-of select="'Водоснабжения и водоотведения'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002014004'">
				<xsl:value-of select="'Газоснабжения'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002014005'">
				<xsl:value-of select="'Перерабатывающее'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002015000'">
				<xsl:value-of select="'Рекреационное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002016000'">
				<xsl:value-of select="'Специальное'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005002017000'">
				<xsl:value-of select="'Не определено'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005003000000'">
				<xsl:value-of select="'Помещение общего пользования'"/>
			</xsl:when>
			<xsl:when test="$AssignationCode='005004000000'">
				<xsl:value-of select="'Техническое помещение'"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
