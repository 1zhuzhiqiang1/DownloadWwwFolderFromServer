/**
 * Created by anyware on 17/2/7.
 */

function onIndexLoad() {
    console.log('onIndexLoad');
    console.log(router);
    if (!localStorage.getItem('first')) {
        router.loadPage('html/first.html');
        localStorage.setItem('first',true);
    } else {
        mainView.router.loadPage('html/main.html');
    }
}

function fun_downloadWwwFile() {
    alert('fun_downloadWwwFile');
    chinasofti.anyware.AnywarePlugin.downloadWwwFolder();
}

/**
 * 跳转到本地文件夹的某个目录
 */
function fun_goto() {
    router.loadPage('file:///Users/anyware/Library/Developer/CoreSimulator/Devices/F6098519-5C1D-4653-AF8E-B5859F71C3CE/data/Containers/Data/Application/48B486F3-7DDA-480C-8F0D-5AFDB9CE61CD/Documents/wwwData/zhuzhiqiang/www/memu.html');
}
