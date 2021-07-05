
// directory of where all the images are
var cmFoncreiBase = '/assets/menu/';


var cmFoncrei =
{
	// main menu display attributes
	//
	// Note.  When the menu bar is horizontal,
	// mainFolderLeft and mainFolderRight are
	// put in <span></span>.  When the menu
	// bar is vertical, they would be put in
	// a separate TD cell.

	// HTML code to the left of the folder item
	mainFolderLeft: '',
	// HTML code to the right of the folder item
	mainFolderRight: '',
	// HTML code to the left of the regular item
	mainItemLeft: '',
	// HTML code to the right of the regular item
	mainItemRight: '',

	// sub menu display attributes

	// 0, HTML code to the left of the folder item
	folderLeft: '',
	// 1, HTML code to the right of the folder item
	folderRight: '<img src=\'/assets/menu/arrow.gif\'>',
	// 2, HTML code to the left of the regular item
	itemLeft: '',
	// 3, HTML code to the right of the regular item
	itemRight: '',
	// 4, cell spacing for main menu
	mainSpacing: 0,
	// 5, cell spacing for sub menus
	subSpacing: 0,
	// 6, auto dispear time for submenus in milli-seconds
	delay: 500
};

// for horizontal menu split
// var cmThemeOffice2003HSplit = [_cmNoClick, '<td class="ThemeOffice2003MenuItemLeft"></td><td colspan="2"><div class="ThemeOffice2003MenuSplit"></div></td>'];
// var cmThemeOffice2003MainHSplit = [_cmNoClick, '<td class="ThemeOffice2003MainItemLeft"></td><td colspan="2"><div class="ThemeOffice2003MenuSplit"></div></td>'];
// var cmThemeOffice2003MainVSplit = [_cmNoClick, '|'];
