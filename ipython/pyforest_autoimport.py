# HOW TO DEACTIVATE AUTO-IMPORT:
# if you dont want to auto-import pyforest, you have two options:
# 0) if you only want to disable the auto-import temporarily and activate it later,
#    you can uncomment the import statement below
# 1) if you never want to auto-import pyforest again, you can delete this file


#  https://stackoverflow.com/questions/15411967/how-can-i-check-if-code-is-executed-in-the-ipython-notebook
def isnotebook():
    try:
        shell = get_ipython().__class__.__name__
        if shell == "ZMQInteractiveShell":
            return True  # Jupyter notebook or qtconsole
        elif shell == "TerminalInteractiveShell":
            return False  # Terminal running IPython
        else:
            return False  # Other type (?)
    except NameError:
        return False  # Probably standard Python interpreter


try:
    import pyforest  # uncomment this line if you temporarily dont want to auto-import pyforest

    if not isnotebook():
        pyforest.disable_javascript_update()  # manually added based on https://github.com/8080labs/pyforest/pull/49/commits/a3e435c72ee94affdb272bd0e0e8f8877f493dbf
except:
    pass
