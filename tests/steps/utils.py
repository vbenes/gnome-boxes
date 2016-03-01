# -*- coding: UTF-8 -*-

from __future__ import unicode_literals
from behave import step
from dogtail.rawinput import pressKey, keyCombo
from time import sleep
from subprocess import call, check_output, CalledProcessError, STDOUT
import pexpect

def get_showing_node_name(name, parent, timeout=30, step=0.25):
    wait = 0
    while len(parent.findChildren(lambda x: x.name == name and x.showing and x.sensitive)) == 0:
        sleep(step)
        wait += step
        if wait == timeout:
            raise Exception("Timeout: Node %s wasn't found showing" %name)

    sleep(step)
    return parent.findChildren(lambda x: x.name == name and x.showing and x.sensitive)[0]

def get_showing_node_rolename(rolename, parent, timeout=30, step=0.25):
    wait = 0
    while len(parent.findChildren(lambda x: x.roleName == rolename and x.showing and x.sensitive)) == 0:
        sleep(step)
        wait += 1
        if wait == timeout:
            raise Exception("Timeout: Node %s wasn't found showing" %rolename)

    return parent.findChildren(lambda x: x.roleName == rolename and x.showing and x.sensitive)[0]

@step('Cannot ping "{vm}"')
def cannot_ping_vm(context, vm):
    cmd = "ping -qn -W1 -s1 -l2 -c1 %s" %context.ips[vm]
    assert call(cmd, shell=True) != 0, "Machine %s is pingable!" %vm

@step('Close warning')
def close_warning(context):
    context.app.findChildren(lambda x: x.name == 'Undo' and x.showing)[0].grabFocus()
    pressKey('Tab')
    pressKey('Enter')
    sleep(1)

@step('Hit "{keycombo}"')
def hit_keycombo(context, keycombo):
    sleep(0.2)
    if keycombo == "Enter":
        pressKey("Enter")
    else:
        keyCombo('%s'%keycombo)

    sleep(0.2)

@step(u'"{pattern}" is visible with command "{command}"')
def check_pattern_visible(context, pattern, command):
    cmd = '/bin/bash -c "%s"' %command
    seconds = 5
    orig_seconds = seconds
    while seconds > 0:
        out = pexpect.spawn(cmd, timeout = 180 )
        if out.expect([pattern, pexpect.EOF]) == 0:
            return True
        seconds = seconds - 1
        sleep(1)
    raise Exception('Did not see the pattern %s in %d seconds' % (pattern, orig_seconds))

@step(u'"{pattern}" is not visible with command "{command}"')
def check_pattern_not_visible(context, pattern, command):
    cmd = '/bin/bash -c "%s"' %command
    seconds = 5
    orig_seconds = seconds
    while seconds > 0:
        out = pexpect.spawn(cmd, timeout = 180)
        if out.expect([pattern, pexpect.EOF]) != 0:
            return True
        seconds = seconds - 1
        sleep(1)
    raise Exception('Did still see the pattern %s after %d seconds' % (pattern, orig_seconds))

@step('Ping "{vm}"')
def ping_vm(context, vm):
    cmd = "ping -qn -W1 -s1 -l2 -c2 %s > /dev/null 2>&1" %context.ips[vm]
    assert call(cmd, shell=True) == 0, "Machine %s is not pingable" %vm

@step('Press "{button}"')
def press_button(context, button):
    get_showing_node_name(button, context.app).click()
    sleep(0.5)

@step('Type "{text}"')
def type_text(context, text):
    call("xdotool type --delay 150 '%s'" %text, shell=True)
    sleep(0.5)

@step('Type text "{text}" and return')
def type_text_and_return(context, text):
    call("xdotool type --delay 150 '%s'" %text, shell=True)
    call("xdotool key 'Return'", shell=True)
    sleep(1)

@step('Wait for "{cmd}" end')
def wait_for_cmd(context, cmd):
    call(cmd, shell=True)
