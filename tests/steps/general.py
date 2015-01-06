# -*- coding: UTF-8 -*-

from behave import step
from dogtail.tree import root
from dogtail.rawinput import typeText, pressKey, keyCombo
from time import sleep
from common_steps import wait_until
from subprocess import call, check_output, Popen, CalledProcessError

@step(u'About is shown')
def about_shown(context):
    assert context.app.child('About Boxes') != None, "About window cannot be focused"

@step(u'Box "{name}" "{state}" exist')
def does_box_exists(context, name, state):
    found = False
    pane = context.app.child(roleName='layered pane')
    for child in pane.children:
        if child.text == name:
            found = True
            break

    if state == 'does':
        assert found == True, "Machine %s was not found in overview" % name
    if state == 'does not':
        assert found == False, "Machine %s was found in overview" % name

@step(u'Boxes are not running')
def boxes_not_running(context):
    assert context.app_class.isRunning() != True, "Boxes window still visible"

@step(u'Boxes app has "{num}" windows')
def number_of_windows(context, num):
    assert len(context.app.children) == int(num), "App has just %s windows not %s" %(len(context.app.children), num)

@step(u'Customize mem to 64 MB')
def customize_vm(context):
    context.app.child(u'Customize…').click()
    sleep(0.5)
    pressKey('Tab')
    pressKey('Tab')
    pressKey('Page_Up')
    pressKey('Page_Up')

    context.app.children[0].children[0].children[3].child('Back').click()
    sleep(0.5)

@step(u'Delete all boxes')
def delete_all(context):
    context.app.findChildren(lambda x: x.name == 'New')[0].grabFocus()
    pane = context.app.child(roleName='layered pane')
    if len(pane.children) != 0:
        for child in pane.children:
            child.click(button=3)
        context.app.child('Delete').click()
        context.app.findChildren(lambda x: x.name == 'Undo' and x.showing)[0].grabFocus()
        pressKey('Tab')
        pressKey('Enter')
        sleep(4)

@step(u'Go into "{vm}" box')
def go_into_vm(context, vm):
    pane = context.app.child(roleName='layered pane')
    for child in pane.children:
        if child.text == vm:
            child.click()
            sleep(0.5)
            break

@step(u'Help is shown')
def help_shown(context):
    sleep(1)
    yelp = root.application('yelp')
    assert yelp.child('Boxes') != None, "Yelp wasn't opened"

@step(u'No box is visible')
def no_box_sign(context):
    assert context.app.child('No boxes found') != None

@step(u'Press "{action}" in vm')
def press_back_in_vm(context, action):
    panel = context.app.child('Boxes').children[0].findChildren(lambda x: x.roleName == 'panel' and x.showing)[0]
    buttons = panel.findChildren(lambda x: x.roleName == 'push button' and x.showing)
    if action == 'back':
        buttons[0].click()
    if action == 'prefs':
        buttons[1].click()
    sleep(0.5)

@step(u'Press "{action}" in alert')
def press_back_in_prefs(context, action):
    button = context.app.child(roleName='alert').child(action)
    button.click()
    sleep(0.5)

@step(u'Quit Boxes')
def quit_boxes(context):
    keyCombo('<Ctrl><Q>')
    sleep(5)

@step(u'Rename "{machine}" to "{name}" via "{way}"')
def rename_vm(context, machine, name, way):
    if way == 'button':
        context.app.child(machine, roleName='push button').click()
        sleep(0.5)
    if way == 'label':
        context.app.child('Name').parent.children[-2].child(roleName='push button').click()
    typeText(name)
    pressKey('Enter')
    sleep(0.5)

@step(u'Save IP for machine "{vm}"')
def save_ip_for_vm(context, vm):
    if not hasattr(context, 'ips'):
        context.ips = {}

    ip_cmd = "head -n 1 /var/lib/libvirt/dnsmasq/default.leases | awk {'print $3'}"

    wait = 0
    while True:
        ip = check_output(ip_cmd, shell=True).strip()
        cmd = "ping -q -c 1 %s > /dev/null 2>&1" % ip
        ret = call(cmd, shell=True)

        if ip in context.ips.values() or ret != 0:
            wait += 1
            sleep(1)
            if wait == 80:
                print check_output('cat /var/lib/libvirt/dnsmasq/default.leases', shell=True)
                print context.ips.values()
                print check_output('date', shell=True)
                print check_output('ip a s', shell=True)
                raise Exception("no new address cannot be found for machine %s" %vm)
        else:
            break

    count = 1
    for key in context.ips.keys():
        if key.find(vm) != -1:
            count += 1
    if count != 1:
        vm = vm + " %s" %count

    context.ips[vm] = ip

@step(u'Select "{vm}" box')
def select_vm(context, vm):
    pane = context.app.child(roleName='layered pane')
    for child in pane.children:
        if child.text == vm:
            child.click(button='3')
            sleep(0.2)
            break

@step(u'Select "{action}" from supermenu')
def select_menu_action(context, action):
    keyCombo("<Super_L><F10>")
    if action == 'About':
        pressKey('Down')
    if action == 'Quit':
        pressKey('Down')
        pressKey('Down')
    pressKey('Enter')

@step(u'Start Boxes')
def start_boxes(context):
    cmd = 'gnome-boxes'
    Popen(cmd, shell=True)
    sleep(1)
    context.app = root.application('gnome-boxes')

@step(u'Start box name "{box}"')
def start_boxes_via_vm(context, box):
    cmd = 'gnome-boxes %s' %box
    Popen(cmd, shell=True)
    sleep(5)
    context.app = root.application('gnome-boxes')

@step(u'Wait until overview is loaded')
def initial_page_loaded(context):
    wait_until(lambda x: x.name != 'New', context.app)
    context.execute_steps(u"""
        * Delete all boxes
        """)