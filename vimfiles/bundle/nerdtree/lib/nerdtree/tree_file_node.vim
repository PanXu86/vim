"CLASS: TreeFileNode
"This class is the parent of the TreeDirNode class and is the
"'Component' part of the composite design pattern between the treenode
"classes.
"============================================================
let s:TreeFileNode = {}
let g:NERDTreeFileNode = s:TreeFileNode

"FUNCTION: TreeFileNode.activate(...) {{{1
function! s:TreeFileNode.activate(...)
    call self.open(a:0 ? a:1 : {})
endfunction

"FUNCTION: TreeFileNode.bookmark(name) {{{1
"bookmark this node with a:name
function! s:TreeFileNode.bookmark(name)

    "if a bookmark exists with the same name and the node is cached then save
    "it so we can update its display string
    let oldMarkedNode = {}
    try
        let oldMarkedNode = g:NERDTreeBookmark.GetNodeForName(a:name, 1)
    catch /^NERDTree.BookmarkNotFoundError/
    catch /^NERDTree.BookmarkedNodeNotFoundError/
    endtry

    call g:NERDTreeBookmark.AddBookmark(a:name, self.path)
    call self.path.cacheDisplayString()
    call g:NERDTreeBookmark.Write()

    if !empty(oldMarkedNode)
        call oldMarkedNode.path.cacheDisplayString()
    endif
endfunction

"FUNCTION: TreeFileNode.cacheParent() {{{1
"initializes self.parent if it isnt already
function! s:TreeFileNode.cacheParent()
    if empty(self.parent)
        let parentPath = self.path.getParent()
        if parentPath.equals(self.path)
            throw "NERDTree.CannotCacheParentError: already at root"
        endif
        let self.parent = s:TreeFileNode.New(parentPath)
    endif
endfunction

"FUNCTION: TreeFileNode.clearBookmarks() {{{1
function! s:TreeFileNode.clearBookmarks()
    for i in g:NERDTreeBookmark.Bookmarks()
        if i.path.equals(self.path)
            call i.delete()
        end
    endfor
    call self.path.cacheDisplayString()
endfunction

"FUNCTION: TreeFileNode.copy(dest) {{{1
function! s:TreeFileNode.copy(dest)
    call self.path.copy(a:dest)
    let newPath = g:NERDTreePath.New(a:dest)
    let parent = b:NERDTreeRoot.findNode(newPath.getParent())
    if !empty(parent)
        call parent.refresh()
        return parent.findNode(newPath)
    else
        return {}
    endif
endfunction

"FUNCTION: TreeFileNode.delete {{{1
"Removes this node from the tree and calls the Delete method for its path obj
function! s:TreeFileNode.delete()
    call self.path.delete()
    call self.parent.removeChild(self)
endfunction

"FUNCTION: TreeFileNode.displayString() {{{1
"
"Returns a string that specifies how the node should be represented as a
"string
"
"Return:
"a string that can be used in the view to represent this node
function! s:TreeFileNode.displayString()
    return self.path.displayString()
endfunction

"FUNCTION: TreeFileNode.equals(treenode) {{{1
"
"Compares this treenode to the input treenode and returns 1 if they are the
"same node.
"
"Use this method instead of ==  because sometimes when the treenodes contain
"many children, vim seg faults when doing ==
"
"Args:
"treenode: the other treenode to compare to
function! s:TreeFileNode.equals(treenode)
    return self.path.str() ==# a:treenode.path.str()
endfunction

"FUNCTION: TreeFileNode.findNode(path) {{{1
"Returns self if this node.path.Equals the given path.
"Returns {} if not equal.
"
"Args:
"path: the path object to compare against
function! s:TreeFileNode.findNode(path)
    if a:path.equals(self.path)
        return self
    endif
    return {}
endfunction

"FUNCTION: TreeFileNode.findOpenDirSiblingWithVisibleChildren(direction) {{{1
"
"Finds the next sibling for this node in the indicated direction. This sibling
"must be a directory and may/may not have children as specified.
"
"Args:
"direction: 0 if you want to find the previous sibling, 1 for the next sibling
"
"Return:
"a treenode object or {} if no appropriate sibling could be found
function! s:TreeFileNode.findOpenDirSiblingWithVisibleChildren(direction)
    "if we have no parent then we can have no siblings
    if self.parent != {}
        let nextSibling = self.findSibling(a:direction)

        while nextSibling != {}
            if nextSibling.path.isDirectory && nextSibling.hasVisibleChildren() && nextSibling.isOpen
                return nextSibling
            endif
            let nextSibling = nextSibling.findSibling(a:direction)
        endwhile
    endif

    return {}
endfunction

"FUNCTION: TreeFileNode.findSibling(direction) {{{1
"
"Finds the next sibling for this node in the indicated direction
"
"Args:
"direction: 0 if you want to find the previous sibling, 1 for the next sibling
"
"Return:
"a treenode object or {} if no sibling could be found
function! s:TreeFileNode.findSibling(direction)
    "if we have no parent then we can have no siblings
    if self.parent != {}

        "get the index of this node in its parents children
        let siblingIndx = self.parent.getChildIndex(self.path)

        if siblingIndx != -1
            "move a long to the next potential sibling node
            let siblingIndx = a:direction ==# 1 ? siblingIndx+1 : siblingIndx-1

            "keep moving along to the next sibling till we find one that is valid
            let numSiblings = self.parent.getChildCount()
            while siblingIndx >= 0 && siblingIndx < numSiblings

                "if the next node is not an ignored node (i.e. wont show up in the
                "view) then return it
                if self.parent.children[siblingIndx].path.ignore() ==# 0
                    return self.parent.children[siblingIndx]
                endif

                "go to next node
                let siblingIndx = a:direction ==# 1 ? siblingIndx+1 : siblingIndx-1
            endwhile
        endif
    endif

    return {}
endfunction

"FUNCTION: TreeFileNode.getLineNum(){{{1
"returns the line number this node is rendered on, or -1 if it isnt rendered
function! s:TreeFileNode.getLineNum()
    "if the node is the root then return the root line no.
    if self.isRoot()
        return s:TreeFileNode.GetRootLineNum()
    endif

    let totalLines = line("$")

    "the path components we have matched so far
    let pathcomponents = [substitute(b:NERDTreeRoot.path.str({'format': 'UI'}), '/ *$', '', '')]
    "the index of the component we are searching for
    let curPathComponent = 1

    let fullpath = self.path.str({'format': 'UI'})


    let lnum = s:TreeFileNode.GetRootLineNum()
    while lnum > 0
        let lnum = lnum + 1
        "have we reached the bottom of the tree?
        if lnum ==# totalLines+1
            return -1
        endif

        let curLine = getline(lnum)

        let indent = nerdtree#indentLevelFor(curLine)
        if indent ==# curPathComponent
            let curLine = nerdtree#stripMarkupFromLine(curLine, 1)

            let curPath =  join(pathcomponents, '/') . '/' . curLine
            if stridx(fullpath, curPath, 0) ==# 0
                if fullpath ==# curPath || strpart(fullpath, len(curPath)-1,1) ==# '/'
                    let curLine = substitute(curLine, '/ *$', '', '')
                    call add(pathcomponents, curLine)
                    let curPathComponent = curPathComponent + 1

                    if fullpath ==# curPath
                        return lnum
                    endif
                endif
            endif
        endif
    endwhile
    return -1
endfunction

"FUNCTION: TreeFileNode.GetRootForTab(){{{1
"get the root node for this tab
function! s:TreeFileNode.GetRootForTab()
    if nerdtree#treeExistsForTab()
        return getbufvar(t:NERDTreeBufName, 'NERDTreeRoot')
    end
    return {}
endfunction

"FUNCTION: TreeFileNode.GetRootLineNum(){{{1
"gets the line number of the root node
function! s:TreeFileNode.GetRootLineNum()
    let rootLine = 1
    while getline(rootLine) !~# '^\(/\|<\)'
        let rootLine = rootLine + 1
    endwhile
    return rootLine
endfunction

"FUNCTION: TreeFileNode.GetSelected() {{{1
"gets the treenode that the cursor is currently over
function! s:TreeFileNode.GetSelected()
    try
        let path = nerdtree#getPath(line("."))
        if path ==# {}
            return {}
        endif
        return b:NERDTreeRoot.findNode(path)
    catch /^NERDTree/
        return {}
    endtry
endfunction

"FUNCTION: TreeFileNode.isVisible() {{{1
"returns 1 if this node should be visible according to the tree filters and
"hidden file filters (and their on/off status)
function! s:TreeFileNode.isVisible()
    return !self.path.ignore()
endfunction

"FUNCTION: TreeFileNode.isRoot() {{{1
"returns 1 if this node is b:NERDTreeRoot
function! s:TreeFileNode.isRoot()
    if !nerdtree#treeExistsForBuf()
        throw "NERDTree.NoTreeError: No tree exists for the current buffer"
    endif

    return self.equals(b:NERDTreeRoot)
endfunction

"FUNCTION: TreeFileNode.makeRoot() {{{1
"Make this node the root of the tree
function! s:TreeFileNode.makeRoot()
    if self.path.isDirectory
        let b:NERDTreeRoot = self
    else
        call self.cacheParent()
        let b:NERDTreeRoot = self.parent
    endif

    call b:NERDTreeRoot.open()

    "change dir to the dir of the new root if instructed to
    if g:NERDTreeChDirMode ==# 2
        exec "cd " . b:NERDTreeRoot.path.str({'format': 'Edit'})
    endif

    silent doautocmd User NERDTreeNewRoot
endfunction

"FUNCTION: TreeFileNode.New(path) {{{1
"Returns a new TreeNode object with the given path and parent
"
"Args:
"path: a path object representing the full filesystem path to the file/dir that the node represents
function! s:TreeFileNode.New(path)
    if a:path.isDirectory
        return g:NERDTreeDirNode.New(a:path)
    else
        let newTreeNode = copy(self)
        let newTreeNode.path = a:path
        let newTreeNode.parent = {}
        return newTreeNode
    endif
endfunction

"FUNCTION: TreeFileNode.open() {{{1
function! s:TreeFileNode.open(...)
    let opts = a:0 ? a:1 : {}
    let opener = g:NERDTreeOpener.New(self.path, opts)
    call opener.open(self)
endfunction

"FUNCTION: TreeFileNode.openSplit() {{{1
"Open this node in a new window
function! s:TreeFileNode.openSplit()
    call nerdtree#deprecated('TreeFileNode.openSplit', 'is deprecated, use .open() instead.')
    call self.open({'where': 'h'})
endfunction

"FUNCTION: TreeFileNode.openVSplit() {{{1
"Open this node in a new vertical window
function! s:TreeFileNode.openVSplit()
    call nerdtree#deprecated('TreeFileNode.openVSplit', 'is deprecated, use .open() instead.')
    call self.open({'where': 'v'})
endfunction

"FUNCTION: TreeFileNode.openInNewTab(options) {{{1
function! s:TreeFileNode.openInNewTab(options)
    echomsg 'TreeFileNode.openInNewTab is deprecated'
    call self.open(extend({'where': 't'}, a:options))
endfunction

"FUNCTION: TreeFileNode.putCursorHere(isJump, recurseUpward){{{1
"Places the cursor on the line number this node is rendered on
"
"Args:
"isJump: 1 if this cursor movement should be counted as a jump by vim
"recurseUpward: try to put the cursor on the parent if the this node isnt
"visible
function! s:TreeFileNode.putCursorHere(isJump, recurseUpward)
    let ln = self.getLineNum()
    if ln != -1
        if a:isJump
            mark '
        endif
        call cursor(ln, col("."))
    else
        if a:recurseUpward
            let node = self
            while node != {} && node.getLineNum() ==# -1
                let node = node.parent
                call node.open()
            endwhile
            call nerdtree#renderView()
            call node.putCursorHere(a:isJump, 0)
        endif
    endif
endfunction

"FUNCTION: TreeFileNode.refresh() {{{1
function! s:TreeFileNode.refresh()
    call self.path.refresh()
endfunction

"FUNCTION: TreeFileNode.rename() {{{1
"Calls the rename method for this nodes path obj
function! s:TreeFileNode.rename(newName)
    let newName = substitute(a:newName, '\(\\\|\/\)$', '', '')
    call self.path.rename(newName)
    call self.parent.removeChild(self)

    let parentPath = self.path.getParent()
    let newParent = b:NERDTreeRoot.findNode(parentPath)

    if newParent != {}
        call newParent.createChild(self.path, 1)
        call newParent.refresh()
    endif
endfunction

"FUNCTION: TreeFileNode.renderToString {{{1
"returns a string representation for this tree to be rendered in the view
function! s:TreeFileNode.renderToString()
    return self._renderToString(0, 0, [], self.getChildCount() ==# 1)
endfunction

"Args:
"depth: the current depth in the tree for this call
"drawText: 1 if we should actually draw the line for this node (if 0 then the
"child nodes are rendered only)
"vertMap: a binary array that indicates whether a vertical bar should be draw
"for each depth in the tree
"isLastChild:true if this curNode is the last child of its parent
function! s:TreeFileNode._renderToString(depth, drawText, vertMap, isLastChild)
    let output = ""
    if a:drawText ==# 1

        let treeParts = ''

        "get all the leading spaces and vertical tree parts for this line
        if a:depth > 1
            for j in a:vertMap[0:-2]
                if g:NERDTreeDirArrows
                    let treeParts = treeParts . '  '
                else
                    if j ==# 1
                        let treeParts = treeParts . '| '
                    else
                        let treeParts = treeParts . '  '
                    endif
                endif
            endfor
        endif

        "get the last vertical tree part for this line which will be different
        "if this node is the last child of its parent
        if !g:NERDTreeDirArrows
            if a:isLastChild
                let treeParts = treeParts . '`'
            else
                let treeParts = treeParts . '|'
            endif
        endif

        "smack the appropriate dir/file symbol on the line before the file/dir
        "name itself
        if self.path.isDirectory
            if self.isOpen
                if g:NERDTreeDirArrows
                    let treeParts = treeParts . 'â–¾ '
                else
                    let treeParts = treeParts . '~'
                endif
            else
                if g:NERDTreeDirArrows
                    let treeParts = treeParts . 'â–¸ '
                else
                    let treeParts = treeParts . '+'
                endif
            endif
        else
            if g:NERDTreeDirArrows
                let treeParts = treeParts . '  '
            else
                let treeParts = treeParts . '-'
            endif
        endif
        let line = treeParts . self.displayString()

        let output = output . line . "\n"
    endif

    "if the node is an open dir, draw its children
    if self.path.isDirectory ==# 1 && self.isOpen ==# 1

        let childNodesToDraw = self.getVisibleChildren()
        if len(childNodesToDraw) > 0

            "draw all the nodes children except the last
            let lastIndx = len(childNodesToDraw)-1
            if lastIndx > 0
                for i in childNodesToDraw[0:lastIndx-1]
                    let output = output . i._renderToString(a:depth + 1, 1, add(copy(a:vertMap), 1), 0)
                endfor
            endif

            "draw the last child, indicating that it IS the last
            let output = output . childNodesToDraw[lastIndx]._renderToString(a:depth + 1, 1, add(copy(a:vertMap), 0), 1)
        endif
    endif

    return output
endfunction

" vim: set sw=4 sts=4 et fdm=marker:
