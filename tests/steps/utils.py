# -*- coding: UTF-8 -*-

from behave import step
from dogtail.rawinput import typeText, pressKey, keyCombo
from time import sleep
from subprocess import call, check_output, CalledProcessError, STDOUT

def get_showing_node_name(name, parent, timeout=30, step=0.25):
    sleep = 0
    while len(parent.findChildren(lambda x: x.name == name and x.showing and x.sensitive)) == 0:
        sleep(step)
        sleep += step
        if sleep == timeout:
            raise Exception("Timeout: Node %s wasn't found showing" %name)

    return parent.findChildren(lambda x: x.name == name and x.showing and x.sensitive)[0]

def get_showing_node_rolename(rolename, parent, timeout=30, step=0.25):
    sleep = 0
    while len(parent.findChildren(lambda x: x.roleName == rolename and x.showing and x.sensitive)) == 0:
        sleep(step)
        sleep += 1
        if sleep == timeout:
            raise Exception("Timeout: Node %s wasn't found showing" %rolename)

    return parent.findChildren(lambda x: x.roleName == rolename and x.showing and x.sensitive)[0]

@step(u'Cannot ping "{vm}"')
def cannot_ping_vm(context, vm):
    cmd = "ping -qn -c 1 %s" %context.ips[vm]
    assert call(cmd, shell=True) != 0, "Machine %s is pingable!" %vm

@step(u'Close warning')
def close_warning(context):
    context.app.findChildren(lambda x: x.name == 'Undo' and x.showing)[0].grabFocus()
    pressKey('Tab')
    pressKey('Enter')
    sleep(1)

@step(u'Hit "{keycombo}"')
def hit_keycombo(context, keycombo):
    sleep(0.2)
    if keycombo == "Enter":
        pressKey("Enter")
    else:
        keyCombo('%s'%keycombo)

    sleep(0.2)

@step(u'"{pattern}" is visible with command "{command}"')
def check_pattern_visible(context, pattern, command):
    sleep(0.2) # time for all to get set
    try:
        out = check_output(command, stderr=STDOUT, shell=True)
    except CalledProcessError as e:
        out = e.output
    assert out.find(pattern) != -1, 'pattern %s is not visible with %s' % (pattern, command)

@step(u'"{pattern}" is not visible with command "{command}"')
def check_pattern_not_visible(context, pattern, command):
    sleep(0.2) # time for all to get set
    out = check_output(command, shell=True)
    assert out.find(pattern) == -1, 'pattern %s is visible with %s' % (pattern, command)

@step(u'Ping "{vm}"')
def ping_vm(context, vm):
    cmd = "ping -qn -c 2 %s > /dev/null 2>&1" %context.ips[vm]
    assert call(cmd, shell=True) == 0, "Machine %s is not pingable" %vm

@step(u'Press "{button}"')
def press_button(context, button):
    get_showing_node_name(button, context.app).click()
    sleep(0.5)

@step(u'Type "{text}"')
def type_text(context, text):
    typeText(text)
    pressKey('Enter')

@step(u'Wait for "{cmd}" end')
def wait_for_cmd(context, cmd):
    call(cmd, shell=True)