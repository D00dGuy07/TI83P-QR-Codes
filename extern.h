#pragma once

#define GRAPH_BUF_POINTER 0x9340

extern void copyToGraph(char* buf);
extern void graphToDisp();
extern void copyToDisp(char* buf);
extern void clearDisp();
extern char getKey();